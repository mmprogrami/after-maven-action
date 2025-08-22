const glob = require('glob');
const libxslt = require('libxslt');
const fs = require('fs');
const path = require('path');
const util = require('util');
const { exec } = require('child_process');




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
const JOB_ENV = path.resolve('job.env');

exec("mvn  -ntp help:evaluate -Dexpression=project.version -q -DforceStdout", (e, stdout, stderr) => {
    setProperty("PROJECT_VERSION", `${stdout}`, JOB_ENV);

    const xsltPath = path.join(__dirname, 'count.xslt');

    let run = 0,
        failed = 0,
        error = 0,
        skipped = 0;
   // Find all XML files
    glob('**/target/{surefire-reports,failsafe-reports}/*.xml', {cwd: process.cwd()}, (err, files) => {
        if (err) throw err;
        for (const file of files) {
            const xml = fs.readFileSync(file, 'utf8');
            const xslt = fs.readFileSync(xsltPath, 'utf8');
            const result = libxslt.parse(xslt).apply(xml);


            result.split('\n').forEach(line => {
                if (!line.trim()) return;
                // Split by comma or spaces
                const fields = line.split(/[, ]+/);
                run += Number(fields[2] || 0);
                failed += Number(fields[4] || 0);
                error += Number(fields[6] || 0);
                skipped += Number(fields[8] || 0);
            });

        }

        setProperty('MAVEN_TESTS_RUN', run, JOB_ENV);
        setProperty('MAVEN_TESTS_FAILED', failed, JOB_ENV);
        setProperty('MAVEN_TESTS_ERROR', error, JOB_ENV);
        setProperty('MAVEN_TESTS_SKIPPED', skipped, JOB_ENV);

        console.log(fs.readFileSync(JOB_ENV, 'utf8'));

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
    });
});