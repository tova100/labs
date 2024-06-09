// index.js
fetch('out.wasm')
  .then(response => response.arrayBuffer())
  .then(bytes => WebAssembly.instantiate(bytes, {}))
  .then(results => {
    console.log('Wasm module loaded');
    const instance = results.instance;
    
    // Assuming `main` is the exported function name from your Wasm module
    if (instance.exports.main) {
      instance.exports.main();
      console.log('Wasm main function executed');
    } else {
      console.error('main function not found in Wasm module');
    }
  })
  .catch(error => {
    console.error('Error loading Wasm module:', error);
  });