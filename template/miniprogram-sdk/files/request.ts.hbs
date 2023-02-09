let requestFun = getFunction('request')
let uploadFileFun = getFunction('uploadFile')

let authHeader: string | null = null
let baseUrl = ''
function getFunction(fun) {
  // @ts-ignore
  if (wx && wx[fun]) {
    // @ts-ignore
    return wx[fun]
    // @ts-ignore
  } else if (tt && tt[fun]) {
    // @ts-ignore
    return tt[fun]
  }
}

export function request(options) {
  return new Promise((resolve, reject) => {
    requestFun({
      url: options.url,
      method: options.method,
      data: options.data,
      header: options.header,
      success(res) {
        resolve(res)
      },
      fail(err) {
        reject(err)
      }
    })
  })
}

export function buildQuery<Output, Input>(url): (data: Input) => Promise<Output>
export function buildQuery<Output>(url): () => Promise<Output>

export function buildQuery(url) {
  return function (data) {
    const search = Object.keys(data || {}).map(key => `${key}=${encodeURIComponent(data[key])}`).join('&')
    const header: Record<string, string> = {}
    if (authHeader) {
      header.Authorization = authHeader
    }
    return request({
      url: `${baseUrl}${url}?${search}`,
      method: 'GET',
      header: header
    }).then(x => x.data)
  }
}
export function buildMutation<Output, Input>(url): (data: Input) => Promise<Output>
export function buildMutation<Output>(url): () => Promise<Output>
export function buildMutation(url) {
  return function (data) {
    const header: Record<string, string> = {}
    if (authHeader) {
      header.Authorization = authHeader
    }
    return request({
      url: `${baseUrl}${url}`,
      method: 'POST',
      header: header,
      data
    }).then(x => x.data)
  }
}

export function uploadFile(options) {
  return new Promise((resolve, reject) => {
    uploadFileFun({
      ...options,
      success(res) {
        resolve(res)
      },
      fail(err) {
        reject(err)
      }
    })
  })
}

export function setAuthHeader(string) {
  authHeader = string
}

export function setBaseUrl(url) {
  baseUrl = url
}
export function getBaseUrl() {
  return baseUrl
}