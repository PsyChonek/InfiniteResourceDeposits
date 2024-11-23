const fs = require('fs');
const path = require('path');
const archiver = require('archiver');
const { exec } = require('child_process');

// Get paths from command-line arguments
const args = process.argv.slice(2);
const dataPath = args[0];
const modsDirectory = args[1];
const factorioPath = args[2];

// Load mod information from info.json
const infoPath = path.join(dataPath, 'info.json');
if (!fs.existsSync(infoPath)) {
  console.error('Error: info.json file not found in the specified data directory.');
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

  // Ensure mods directory exists
  if (!fs.existsSync(modsDirectory)) {
    console.error('Error: Factorio mods directory does not exist.');
    process.exit(1);
  }

  // Copy the ZIP to the mods directory
  const destinationPath = path.join(modsDirectory, outputFileName);
  fs.copyFile(outputFilePath, destinationPath, (err) => {
    if (err) {
      console.error('Error copying archive to mods directory:', err);
      process.exit(1);
    }
    console.log(`Archive successfully copied to: ${destinationPath}`);

    // Launch Factorio
    if (!fs.existsSync(factorioPath)) {
      console.error('Error: Factorio executable not found.');
      process.exit(1);
    }

    console.log('Starting Factorio...');
    exec(`"${factorioPath}"`, (error, stdout, stderr) => {
      if (error) {
        console.error(`Error launching Factorio: ${error.message}`);
        return;
      }
      if (stderr) {
        console.error(`Factorio stderr: ${stderr}`);
      }
      console.log(`Factorio stdout: ${stdout}`);
    });
  });
});

archive.on('error', function (err) {
  throw err;
});

// Pipe archive data to the output file
archive.pipe(output);

// Append only the contents of the 'data' directory inside a folder named after the mod
if (fs.existsSync(dataPath) && fs.statSync(dataPath).isDirectory()) {
  archive.directory(dataPath, `${modName}_${version}`);
} else {
  console.error('Error: data directory not found in the specified path.');
  process.exit(1);
}

// Finalize the archive
archive.finalize();
