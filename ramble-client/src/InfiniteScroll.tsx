import { FC, useEffect } from 'react';
import { useInView } from 'react-intersection-observer';

import Loader from './Loader';

interface InfiniteScrollProps {
    /**
     * The root element of the interaction observer. Use this 
     * in case the scroll parent is different from body.
     */
    root?: Element

    /**
     * Whether the infinite scroll has a next
     * page or not, will determine if it is fetching.
     */
    hasNextPage: boolean

    /**
     * Define this as the function to fetch the next elements 
     * in the page.
     */
    fetchNextPage: () => void

    /**
     * Will also determine if the scroll should be fetching,
     * as we want to fetch if this changes meaning until
     * content fills the screen.
     */
    renderLength: number

    /**
     * Render the elements in the infinite scroll here.
     */
    children?: React.ReactNode

    /**
     * Component to be shown when loading or fetching
     * items.
     */
    loadingComponent?: React.ReactNode

    /**
     * Component to be shown when the scroll can't load 
     * anything anymore
     */
    endComponent?: React.ReactNode
}

/**
 * This is the possible refactored infinite scroll version.
 */
const InfiniteScroll: FC <InfiniteScrollProps>= ({ root, hasNextPage, fetchNextPage, renderLength, loadingComponent, endComponent, children }) => {
    const [moreRef, inView ] = useInView({ root, threshold: 1.0 });
    
    useEffect(() => {
        if (inView && hasNextPage)
            fetchNextPage && fetchNextPage();
    }, [ inView, hasNextPage, renderLength ])

    return (
        <>
            { children}
            <div className='flex items-center justify-center text-center w-full p-5 bg-white' ref={moreRef}>{hasNextPage ? loadingComponent || <Loader /> : endComponent || <span>No more</span> }</div>
        </>
    )
}

export default InfiniteScroll;