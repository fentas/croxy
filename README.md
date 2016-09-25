## CrOxy
**cr**awl the web through a pr**oxy** (rotating IPs, throttling requests, response validating and more) 

#### Rotating IPs

#### Throttling requests

#### Response validation

#### Sessions

###### List sessions

###### Delete a session

#### Request Headers

#### Error Codes
| X-Croxy-Error          | Response Code | Error Message   |
|:---------------------- |:-------------:|:--------------- |
| bad_session_id         | 400           | Incorrect session ID |
| user_session_limit     | 400           | Session limit exceeded |
| bad_auth               | 407           | |
| too_many_conns         | 429           | Too many connections* |
| header_auth            | 470           | Unauthorized Crawlera header |
|                        | 500           | Unexpected error |
| nxdomain               | 502           | Error looking up domain |
| econnrefused           | 502           | Connection refused |
| econnreset             | 502           | Connection reset |
| socket_closed_remotely | 502           | Server closed socket connection |
| send_failed            | 502           | Send failed |
| noslaves               | 503           | No available proxies |
| slavebanned            | 503           | Website crawl ban |
| serverbusy             | 503           | Server busy: too many outstanding requests |
| timeout                | 504           | Timeout from upstream server |
| msgtimeout             | 504           | Timeout processing HTTP stream |
| bad_header             | 540           | Bad header value for <some_header> |

#### Inspirations / References
- https://github.com/jgontrum/proxies-rotator
`Rotating IPs for web scraping - it's working again!`
- http://cbonte.github.io/haproxy-dconv/1.6/
`HAProxy Documentation`
- https://www.lua.org/pil/contents.html#22
`Programming in Lua (first edition)`
- https://github.com/docker-library/haproxy
`Docker Official Image packaging for HAProxy http://www.haproxy.org/`
- http://blog.databigbang.com/running-your-own-anonymous-rotating-proxies/
`Running Your Own Anonymous Rotating Proxies`
- https://scrapinghub.com/crawlera/
`*commercial solution* Say goodbye to IP bans and proxy management`

#### FAQ

###### Working with HTTPS
HTTPs request over HTTP proxy

###### Working with Cookies

######
