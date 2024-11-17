const fs = require('fs');
const path = require('path');
const archiver = require('archiver');

// Load mod information from info.json
const infoPath = path.join(__dirname, 'data', 'info.json');
if (!fs.existsSync(infoPath)) {
  console.error('Error: info.json file not found in the data directory.');
  process.exit(1);
}

const info = JSON.parse(fs.readFileSync(infoPath, 'utf8'));
const version = info.version;
const modName = info.name;

if (!version || !modName) {
  console.error('Error: Could not find "name" or "version" field in info.json.');
  process.exit(1);
}

// Set the output ZIP file name with version
const outputFileName = `${modName}_${version}.zip`;
const outputFilePath = path.join(__dirname, outputFileName);

// Create a file to stream archive data to.
const output = fs.createWriteStream(outputFilePath);
const archive = archiver('zip', {
  zlib: { level: 9 } // Maximum compression
});

output.on('close', function () {
  console.log(`Packed successfully: ${archive.pointer()} total bytes`);
  console.log(`Output file: ${outputFileName}`);
});

archive.on('error', function (err) {
  throw err;
});

// Pipe archive data to the output file
archive.pipe(output);

// Append only the contents of the 'data' directory inside a folder named after the mod
const dataDirectory = path.join(__dirname, 'data');
if (fs.existsSync(dataDirectory) && fs.statSync(dataDirectory).isDirectory()) {
  archive.directory(dataDirectory, `${modName}_${version}`);
} else {
  console.error('Error: data directory not found in the current directory.');
  process.exit(1);
}

// Finalize the archive
archive.finalize();