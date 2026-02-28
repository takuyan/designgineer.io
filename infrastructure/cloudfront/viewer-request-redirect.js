function handler(event) {
  var request = event.request;
  var headers = request.headers;
  var host = headers.host && headers.host.value ? headers.host.value.toLowerCase() : '';

  // Canonical host: always redirect www to apex over HTTPS.
  if (host === 'www.designgineer.io') {
    return {
      statusCode: 301,
      statusDescription: 'Moved Permanently',
      headers: {
        location: { value: 'https://designgineer.io' + request.uri + (request.querystring ? '?' + request.querystring : '') }
      }
    };
  }

  return request;
}
