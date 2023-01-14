
import { HttpTransportHookRequest, SKIP, CANCEL } from 'generated/fireboom.hooks'
import type { WunderGraphRequest } from 'fireboom-wundersdk'

export default async function onOriginRequest(hook: HttpTransportHookRequest) : Promise<WunderGraphRequest | SKIP | CANCEL>{
	// TODO: 在此处添加代码
	return hook.request
}
