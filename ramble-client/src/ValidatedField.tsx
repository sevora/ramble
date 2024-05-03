import { ComponentPropsWithoutRef, FormEventHandler, useState } from 'react';

interface ValidatedFieldProps extends ComponentPropsWithoutRef<"input"> {
    /**
     * Whether the element should express that its valid or invalid.
     */
    valid: boolean;

    /**
     * The message that appears when the field is valid.
     */
    successMessage?: string;

    /**
     * The message that appears when the field is invalid.
     */
    errorMessage?: string;
}

/**
 * This is a reusable component for validated fields, which show a success or error message upon meeting
 * a set criteria according to the boolean valid field. It is an extension of an HTMLInputElement.
 */
function ValidatedField({ valid, successMessage, errorMessage, onInput, ...otherProperties }: ValidatedFieldProps) {
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