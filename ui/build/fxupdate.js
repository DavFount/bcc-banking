var fs = require('fs')
fs.readFile('../fxmanifest.lua', 'utf8', function (err, data) {
  if (err) throw err

  console.log(process.env.NODE_ENV)

  if (process.env.NODE_ENV) {
    data = data.replaceAll('ui/dist/index.html', 'ui/shim.html')
    console.log('Changing to Dev')
  } else {
    data = data.replaceAll('ui/shim.html', 'ui/dist/index.html')
    console.log('Changing to Prod')
  }

  fs.writeFile('../fxmanifest.lua', data, function (err) {
    if (err) throw err
    console.log('fxmanifest file updated')
  })
})
