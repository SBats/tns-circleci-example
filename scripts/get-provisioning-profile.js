#! /usr/bin/env node

// Vendors
const profilesFinder = require('ios-mobileprovision-finder')

// Parameters
const bundleId = process.argv[2]
const context = process.argv[3]

const certificates = profilesFinder.cert.read()
const provisionProfiles = profilesFinder.provision.read()
const result = profilesFinder.provision.select(provisionProfiles, {
  AppId: bundleId,
  Certificates: certificates.valid,
  Type: context,
})
if (result.eligable.length === 0) {
  console.error(`
    Unable to find a matching provisioning profile for appId ${bundleId}
  `)
  process.exit(1)
}
console.log(result.eligable[0].UUID)
process.exit()
