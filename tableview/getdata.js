const fs = require('node:fs');

try {
    fetch('https://www.ag-grid.com/example-assets/space-mission-data.json')
    .then((response) => response.json())
    .then((data) => fs.writeFileSync('./data.txt', JSON.stringify(data)));
} catch (err) {
    console.error(err);
}