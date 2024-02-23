# Piano Analytics server-side using sGTM

> Disclaimer : this repository is expected to be used by power user of both sGTM and GTM.


## Summary

### Content

This repo contains 2 templates :
- A Client template "Piano Analytics - Client.tpl" , to be used in sGTM for S2S or Hybrid tracking.
- A Server Tag template "Piano Analytics - Tag.tpl" , to be used in sGTM for sending data to your Piano Analytics property.

### Usage

Download and import the templates in the appriorate container.
It is intended to be used **as is**.

Ideally, the front tag should have all the data required by Piano, and the server tag should only copy data received.
Event data are parsed and isolated to ease the use of specific variables.

More details below for specific tracking

##### Client template
The default path here is /pa so you will need to update this path on the client-side variable configuration.
You will have to specify the cookie domain in this client. The common way is to specify ".domain.com" to include subdomains

##### Tag template
You only have to specify the collectDomain you can find in the Piano Analytics interface.
If your front tag is sending a "site id", it will use this value. Else, you should specify it in the server tag.
