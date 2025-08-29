const glob = require('glob');
const fs = require('fs');
const path = require('path');
const SaxonJS = require("saxon-js");

const JOB_ENV = path.resolve('job.env');

function setProperty(key, value, filePath) {
  let lines = [];
  if (fs.existsSync(filePath)) {
    lines = fs.readFileSync(filePath, 'utf8').split('\n');
  }
  let found = false;
  lines = lines.map(line => {
    if (line.startsWith(`${key}=`)) {
      found = true;
      return `${key}=${value}`;
    }
    return line;
  });
  if (!found) lines.push(`${key}=${value}`);
  fs.writeFileSync(filePath, lines.filter(Boolean).join('\n') + '\n');
}

function globAsync(pattern, options) {
  return new Promise((resolve, reject) => {
    glob(pattern, options, (err, files) => {
      if (err) reject(err);
      else resolve(files);
    });
  });
}

async function runMavenVersion() {

    const { exec } = require('child_process');
    return new Promise((resolve, reject) => {
        exec("mvn  -ntp help:evaluate -Dexpression=project.version -q -DforceStdout", (e, stdout, stderr) => {
            setProperty("PROJECT_VERSION", `${stdout}`, JOB_ENV);
            resolve();
        });
    });
}
const failuresAndErrorsPath = path.join(__dirname, 'failures_and_errors.sef.json');


async function processTestReports(files) {
    const countSefPath = path.join(__dirname, 'count.sef.json')

    let run = 0,
        failed = 0,
        error = 0,
        skipped = 0;

    await Promise.all(files.map(async (file) => {
        try {
            const output = await SaxonJS.transform({
                    stylesheetFileName: countSefPath,
                    sourceFileName: file,
                    destination: "serialized"
                }, "async"
            );
            const result = output.principalResult;
            result.split('\n').forEach(line => {
                if (!line.trim()) return;
                // Split by comma or spaces
                const fields = line.split(/[, ]+/);
                run += Number(fields[2] || 0);
                failed += Number(fields[4] || 0);
                error += Number(fields[6] || 0);
                skipped += Number(fields[8] || 0);
            });

        } catch {
            console.log(e);
        }
    }));
    setProperty('MAVEN_TESTS_RUN', run, JOB_ENV);
    setProperty('MAVEN_TESTS_FAILED', failed, JOB_ENV);
    setProperty('MAVEN_TESTS_ERROR', error, JOB_ENV);
    setProperty('MAVEN_TESTS_SKIPPED', skipped, JOB_ENV);
    console.log(fs.readFileSync(JOB_ENV, 'utf8'));
    return {run, failed, error, skipped};
}
async function printFailuresAndErrors(files) {
    await Promise.all(files.map(async (file) => {

        const output = SaxonJS.transform({
            stylesheetFileName: failuresAndErrorsPath,
            sourceFileName: file,
            destination: "serialized",
            stylesheetParams: {
                artifactIdPad: 30,
                namePad: 50
            }
        }, "async");

        if (output.principalResult) {
            console.log(output.principalResult);
        }
    }));
}

async function main() {
    //console.log(process.env);
    if ((process.env['INPUT_DETERMINE_VERSION'] || 'true') === 'true') {
        await runMavenVersion();
    }
    const files = await globAsync('**/target/{surefire-reports,failsafe-reports}/*.xml', {cwd: process.cwd()});
    files.sort((a, b) => fs.statSync(a).mtime - fs.statSync(b).mtime);

    const {run, failed, error} = await processTestReports(files);

    await printFailuresAndErrors(files);

    if (error > 0) {
        console.error(`Some (${error}) tests had errors. Exit 1.`);
        process.exit(1);
    } else if (failed > 0) {
        console.error(`Some (${failed}) tests had failures. Exit 2`);
        process.exit(2);
    } else if (run === 0) {
        console.error('Everything seems ok, but no tests run. Exit 0');
        process.exit(0);
    } else {
        console.log('All tests passed. Exit 0');
        process.exit(0);
    }
}

main();