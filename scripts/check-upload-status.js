#! /usr/bin/env node

// Vendors
const fetch = require('node-fetch')

// Parameters
const token = process.argv[2]
const uploadInfos = JSON.parse(process.argv[3])

const jobStatusUrl = `https://upload.diawi.com/status?token=${token}&job=${uploadInfos.job}`
let statusCheckerTimer

const endScript = exitCode => {
  clearInterval(statusCheckerTimer)
  process.exit(exitCode)
}

const onStatusCheckSuccess = message => {
  // See https://dashboard.diawi.com/docs/apis/upload for response structure
  console.log(`SUCCESS - status: ${message}`)
  endScript(0)
}

const onStatusCheckError = message => {
  console.error(`ERROR - status: ${message}`)
  endScript(1)
}

const checkStatus = limit => {
  let tries = limit
  statusCheckerTimer = setInterval(() => {
    fetch(jobStatusUrl)
      .then(res => res.json())
      .then(res => {
        if (res.status === 4000 || res.error) onStatusCheckError(res.message)
        if (res.status === 2000) onStatusCheckSuccess(res.message)
        if (res.status === 2001) {
          if (tries > 0) {
            console.log(tries)
            return tries--
          }
          onStatusCheckError(`
            ERROR - Couldn't get job status, please check on diawi dashboard:
            https://dashboard.diawi.com
          `)
        }
      })
      .catch(onStatusCheckError)
  }, 3000)
}

checkStatus(5)
