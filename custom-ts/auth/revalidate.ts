
import { AuthenticationHookRequest, AuthenticationResponse } from 'generated/fireboom.hooks'

export default async function revalidate(hook: AuthenticationHookRequest) : Promise<AuthenticationResponse>{
	// TODO: 在此处添加代码
	return {
		status:'deny',
		message: 'string'
	}
}
