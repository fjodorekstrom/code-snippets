const { Storage } = require('@google-cloud/storage');
const storage = new Storage();

const readFile = (bucketName, subPath, fileName) => {
  const readFileStream = storage.bucket(bucketName).file(`${subPath}/${fileName}`).createReadStream();
  let data = '';

  return new Promise((resolve, reject) => {
    readFileStream.on("data", chunk => data += chunk);
    readFileStream.on("end", () => resolve(JSON.parse(data.toString('utf-8'))));
    readFileStream.on("error", error => reject(error));
  });
};

const writeFile = async (bucketName, subPath, fileName, data) => {
  const writeFileStream = storage.bucket(bucketName).file(`${subPath}/${fileName}`).createWriteStream();
  await writeFileStream.write(JSON.stringify(data));
  writeFileStream.end();
  return new Promise((resolve, reject) => {
    writeFileStream.on("error", error => reject(error));
    writeFileStream.on("finish", () => resolve('done'))
  });
};

module.exports = {
  readFile,
  writeFile
};
