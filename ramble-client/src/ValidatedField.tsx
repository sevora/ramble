import React, { FC, FormEventHandler, useState } from 'react';

interface ValidatedFieldProps extends React.InputHTMLAttributes<HTMLInputElement> {
    /**
     * 
     */
    valid: boolean;

    /**
     * 
     */
    successMessage?: string;

    /**
     * 
     */
    errorMessage?: string;
}

/**
 * 
 * @returns 
 */
const ValidatedField: FC<ValidatedFieldProps> = ({ valid, successMessage, errorMessage, onInput, ...otherProperties }) => {
    const [ hasReceivedInput, setHasReceivedInput ] = useState(false);
    const message = valid ? successMessage : errorMessage;
    const color = valid ? 'rgb(132 204 22)' : 'rgb(239 68 68)';

    const trigger: FormEventHandler<HTMLInputElement> = (event) => {
        if (onInput) onInput(event);
        setHasReceivedInput(true);
    }

    return (
        <>
            <input onInput={trigger} style={{ borderColor: hasReceivedInput ? color : undefined }} className='shadow border rounded w-full py-2 px-3 mb-3' {...otherProperties} />
            { hasReceivedInput && <p style={{ color: hasReceivedInput ? color : undefined }} className='text-xs italic'>{message}</p> }
        </>
    )
}

export default ValidatedField;