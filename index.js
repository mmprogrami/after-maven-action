const glob = require('glob');
const libxslt = require('libxslt');
const fs = require('fs');
const path = require('path');


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
const xsltPath = path.join(__dirname, 'count.xslt');

let t = 0, f = 0, e = 0, s = 0;
// Find all XML files
glob('**/target/{surefire-reports,failsafe-reports}/*.xml', async (err, files) => {
  if (err) throw err;
  for (const file of files) {
    const xml = fs.readFileSync(file, 'utf8');
    const xslt = fs.readFileSync(xsltPath, 'utf8');
    const result = libxslt.parse(xslt).apply(xml);


    result.split('\n').forEach(line => {
        if (!line.trim()) return;
        // Split by comma or spaces
        const fields = line.split(/[, ]+/);
        t += Number(fields[2] || 0);
        f += Number(fields[4] || 0);
        e += Number(fields[6] || 0);
        s += Number(fields[8] || 0);
    });

  }


    setProperty('MAVEN_TESTS_RUN',t, JOB_ENV);
    setProperty('MAVEN_TESTS_FAILED',f, JOB_ENV);
    setProperty('MAVEN_TESTS_ERROR', e, JOB_ENV);
    setProperty('MAVEN_TESTS_SKIPPED', s, JOB_ENV);
    // Add any additional logic from exit_after_maven.sh here
});