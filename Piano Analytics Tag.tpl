//necessary APIs
const getAllEventData = require('getAllEventData');
const sendHttpRequest = require('sendHttpRequest');
const JSON = require('JSON');
let queryParams;

//get all event data
const event = getAllEventData();

//
if (data.siteId) {
  queryParams = "s="+data.siteId+"&idclient="+event.client_id;
} else {
  queryParams = "s="+event.site_id+"&idclient="+event.client_id;
}

//construct the request URL consisting of collection domain, path, and query string
let url = 'https://'+ data.collectDomain + data.requestPath + '?' + queryParams;

//set request headers
let headers = {};
headers["user-agent"] = event.user_agent;
headers["x-forwarded-for"] = event.ip_override;
//header parameters allowing you to have the response from the server in preview mode
headers["Content-Type"] = "application/json";


//set request body
const postBody = '{"events":['+ JSON.stringify(event.event) +']}';

//make POST request
sendHttpRequest(url, {
  headers: headers,
  method: 'POST',
  timeout: 500,
}, postBody);

data.gtmOnSuccess();
