
const admin = {
    properties: {
        email: {
            $ref: 'defs#/definitions/Admin/email'
        },
        phone: {
            $ref: 'defs#/definitions/Admin/phone'
        },
        username: {
            $ref: 'defs#/definitions/Admin/username'
        },
        password: {
            $ref: 'defs#/definitions/Admin/password'
        },
        status: {
            $ref: 'defs#/definitions/Admin/status'
        },
    },
}
export const adminCreate = {
    type: 'object',
    $id: 'adminCreate',
    additionalProperties: false,
    properties: admin.properties,
    // errorMessage: admin.errorMessage,
    required: ['email', 'phone', 'username', 'password', 'status']
}
