___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Piano Analytics Tag",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Sending events to Piano Analytics",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "collectDomain",
    "displayName": "Collection Domain",
    "simpleValueType": true,
    "help": "Piano Analytics collection domain (can be a CDDC if configured for your account).",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": "xxxxxxx.pa-cd.com"
  },
  {
    "type": "TEXT",
    "name": "requestPath",
    "displayName": "Request Path",
    "simpleValueType": true,
    "help": "Path of the request sent to Piano Analytics",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "defaultValue": "/event",
    "valueHint": "/event"
  },
  {
    "type": "TEXT",
    "name": "siteId",
    "displayName": "Site ID",
    "simpleValueType": true,
    "help": "If you wish to send the data to a different site ID than the one specified in the client-side tag, add it there. Otherwise, the value of the request captured by the client will be used.",
    "valueValidators": [
      {
        "type": "NUMBER"
      }
    ],
    "valueHint": "123456"
  }
]


___SANDBOXED_JS_FOR_SERVER___

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

//set request body
const postBody = '{"events":['+ JSON.stringify(event.event) +']}';

//make POST request
sendHttpRequest(url, {
  headers: headers,
  method: 'POST',
  timeout: 500,
}, postBody);

data.gtmOnSuccess();


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_event_data",
        "versionId": "1"
      },
      "param": [
        {
          "key": "eventDataAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 23/02/2024 14:45:17


