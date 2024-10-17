import { ComponentPropsWithoutRef } from 'react';

interface NavigationButtonProps extends ComponentPropsWithoutRef<"div"> {
    /**
     * This is meant to have a component constructor (not the result rather the constructor)
     * of icon that accepts className attribute.
     */
    InActiveIcon: any;

    /**
     * This is meant to have a component constructor (not the result rather the constructor)
     * of icon that accepts className attribute.
     */
    ActiveIcon: any;

    /**
     * Whether to show the active icon or not.
     */
    active?: boolean;

    /**
     * What the label is for the navigation icon
     */
    label?: string;
}

/**
 * This is a reusable navigation button for the 
 * purpose of decluttering the code I wrote.
 */
function NavigationButton({ InActiveIcon, ActiveIcon, active = false, label = '', className, ...otherProperties }: NavigationButtonProps) {
    return (
        <div className={`flex items-center justify-center p-2 w-full hover:bg-slate-100 cursor-pointer ${className || ''}`}  { ...otherProperties }>
            <div className='mr-2'>
                {
                    active ? 
                        <ActiveIcon className='text-xl text-slate-800'/> :
                        <InActiveIcon className='text-xl text-slate-800' />
                }
            </div>
            <div className='hidden sm:inline' style={{ fontWeight: active ? 600 : undefined }}>{label}</div>
        </div>
    )
};

export default NavigationButton;