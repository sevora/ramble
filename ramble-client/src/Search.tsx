import { FC } from 'react';

/**
 * 
 */
const Search: FC = () => {
    return (
        <div>
            <div className='p-5 sm:px-20 bg-white border-b-2 flex'>
                <input className='shadow border w-full py-2 px-3 rounded-full bg-neutral-100' type='text' placeholder='Enter keywords here, find posts, and accounts...' />
                <button className='bg-slate-800 hover:bg-neutral-950 text-white ml-3 py-2 px-10 rounded-full'>Search</button>
            </div>
        </div>
    )
};

export default Search;