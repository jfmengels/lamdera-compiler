const pathToWasm = "";

// Assume add.wasm file exists that contains a single function adding 2 provided arguments
const fs = require('node:fs');
// Use the readFileSync function to read the contents of the "add.wasm" file
const wasmBuffer = fs.readFileSync(pathToWasm);
// Use the WebAssembly.instantiate method to instantiate the WebAssembly module
WebAssembly.instantiate(wasmBuffer).then(wasmModule => {
  // Exported function lives under instance.exports object
  const { add, check } = wasmModule.instance.exports;
  console.log({add})
  console.log({check})
  const result = check("some");
  console.log(result);
});