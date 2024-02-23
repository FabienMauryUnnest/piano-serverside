___INFO___

{
  "type": "CLIENT",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Piano Analytics Client",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Client for Piano Analytics requests",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "requestPath",
    "displayName": "Request path",
    "simpleValueType": true,
    "help": "The path of the requests which should be handled by this client (has to start with /).",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "defaultValue": "/pa"
  },
  {
    "type": "TEXT",
    "name": "cookieDomain",
    "displayName": "Cookie Domain",
    "simpleValueType": true,
    "help": "Domain of cookie deposit",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "valueHint": ".site.com"
  }
]


___SANDBOXED_JS_FOR_SERVER___

//Necessary APIs
const claimRequest = require('claimRequest');
const getRequestPath = require('getRequestPath');
const returnResponse = require('returnResponse');
const runContainer = require('runContainer');
const setPixelResponse = require('setPixelResponse');
const getRequestQueryParameters = require('getRequestQueryParameters');
const getRemoteAddress = require('getRemoteAddress');
const getRequestHeader = require('getRequestHeader');
const setResponseHeader = require('setResponseHeader');
const getRequestBody = require('getRequestBody');
const getCookie = require('getCookieValues');
const setCookie = require('setCookie');
const JSON = require('JSON');

//Get the request path for claiming the request
const requestPath = getRequestPath();
//Get the query string parameters and store them in an object
const queryParameters = getRequestQueryParameters();
//Get the IP and store it in a variable
const ip = getRemoteAddress();
//Get the UA and store it in a variable
const ua = getRequestHeader('user-agent');

//Get request body, store it in a variable, parse as JSON object
//Note that there might be some further parsing or structuring needed depending on the format of the request body
const requestBody = getRequestBody();
const requestBodyObject = JSON.parse(requestBody);

//Claim the request according to the Request Path input field
if (requestPath.indexOf(data.requestPath) > -1) {

  claimRequest();
  setPixelResponse();
  
  const events = requestBodyObject['events'];
  
  const max = events.length - 1;
        
  events.forEach((event, index) => {
    //Create event data object
    const obj = {};  
    
    obj.event_name = event.name;
    obj.client_id = queryParameters.idclient;
    obj.site_id = queryParameters.s;
    obj.event = event;
    obj.ip_override = ip;
    obj.user_agent = ua;
    
    runContainer(obj, () => {
      if (index === max) {
        
        // Legacy cookies PA SDK < 6.7.0
        const pa_vid = getCookie('pa_vid');
        if (pa_vid && pa_vid.length) {
          setCookie('pa_vid', pa_vid[0], {
            domain: data.cookieDomain,
            'max-age': 34214400, //396 jours
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        const pa_user = getCookie('pa_user');
        if (pa_user && pa_user.length) {
          setCookie('pa_user', pa_user[0], {
            domain: data.cookieDomain,
            'max-age': 34214400,
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        const pa_privacy = getCookie('pa_privacy');
        if (pa_privacy && pa_privacy.length) {
          setCookie('pa_privacy', pa_privacy[0], {
            domain: data.cookieDomain,
            'max-age': 34214400,
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        // New cookies PA SDK > 6.7.0
        const pcid = getCookie('_pcid');
        if (pcid && pcid.length) {
          setCookie('_pcid', pcid[0], {
            domain: data.cookieDomain,
            'max-age': 34214400,
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        const pctx = getCookie('_pctx');
        if (pctx && pctx.length) {
          setCookie('_pctx', pctx[0], {
            domain: data.cookieDomain,
            'max-age': 34214400,
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        const pprv = getCookie('_pprv');
        if (pprv && pprv.length) {
          setCookie('_pprv', pprv[0], {
            domain: data.cookieDomain,
            'max-age': 34214400,
            path: '/',
            secure: true,
            sameSite: 'lax'
          });
        }
        
        setPixelResponse();
        
        // Make sure no CORS errors pop up with the response
        const origin = getRequestHeader('Origin');
		if (origin) {
          setResponseHeader('Access-Control-Allow-Origin', origin);
          setResponseHeader('Access-Control-Allow-Credentials', 'true');
        }
        
        returnResponse();
      }
    });
  });
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "read_request",
        "versionId": "1"
      },
      "param": [
        {
          "key": "requestAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "headerAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queryParameterAccess",
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
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
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
        "publicId": "return_response",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_pcid"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_pctx"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "_pprv"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
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
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
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
        "publicId": "run_container",
        "versionId": "1"
      },
      "param": []
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 23/02/2024 14:45:08


