import errorProperties from 'err-code'
import {
    ApplicationError
} from './ApplicationError.js'
import capitalize from 'lodash/capitalize.js'

export const NotFound = (name, description) => {
    return errorProperties(ApplicationError.prepare('NotFoundException', {
        code: `${name}-not-found`,
        message: `${capitalize(name)} Not Found`,
        description
    }))
}

export const NotSaved = (name, description) => {
    return errorProperties(ApplicationError.prepare('NotSavedException', {
        code: `${name}-not-${description}`,
        message: `${capitalize(name)} Not ${capitalize(description)}`
    }))
}

export const NotValid = (name, description) => {
    return errorProperties(ApplicationError.prepare('NotValidException', {
        code: `${name}-not-valid`,
        message: description
    }))
}
export const AuthenticationFailed = () => {
    return errorProperties(ApplicationError.prepare('UnauthorizedException', {
        code: 'invalid-credential',
        message: 'Authentication Failed'
    }))
}

export const AlreadyExists = (name, description) => {
    return errorProperties(ApplicationError.prepare('ConflictException', {
        code: `${name}-already-exists`,
        message: `${capitalize(name)} Already Exists`,
        description
    }))
}
export const MemberExists = (name, description) => {
    return errorProperties(ApplicationError.prepare('ConflictException', {
        code: `${name}-already-exists`,
        message: `${capitalize(name)} Member Exist`,
        description
    }))
}

export const FileLimit = (name, description) => {
    return errorProperties(ApplicationError.prepare('TooLargeException', {
        code: `${name}-toolarge`,
        message: `${capitalize(name)} Too Large`,
        description
    }))
}

export const SomethingWentWrong = description => {
    return errorProperties(ApplicationError.prepare('ServerException', {
        code: 'server/something-went-wrong',
        message: 'Something went wrong',
        description
    }))
}

export const CustomError = description => {
    return errorProperties(ApplicationError.prepare('ClientException', {
        code: 'client/custom-error',
        message: 'Custom Error',
        description
    }))
}