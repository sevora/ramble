import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import axios from 'axios';

import Post from './Post';
import Profile from './Profile';

/**
 * This is the search page component allowing one to search by keywords
 * and get posts or accounts with said keyword.
 */
const Search: FC = () => {
    const [searchContent, setSearchContent] = useState<string>('');
    const [searchActive, setSearchActive] = useState<boolean>(false);

    const [posts, setPosts] = useState<{ postId: string }[]>([]);
    const [accounts, setAccounts] = useState<{ username: string }[]>([]);

    const [category, setCategory] = useState<'post' | 'account'>('post');
    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(false);

    const [moreRef, inView] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    /**
     * Use this to get the posts at category and page.
     */
    const getPosts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/search/post`, { content: searchContent, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * This is the logic to load more posts for infinite scrolling.
     */
    const loadMorePosts = async () => {
        const more = await getPosts(page);

        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

    /**
     * Use this to get accounts at a specified page.
     */
    const getAccounts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/search/account`, { username: searchContent, page }, { withCredentials: true });
        return response.data.users as { username: string }[];
    }

    /**
     * This loads more accounts for infinite scrolling.
     */
    const loadMoreAccounts = async () => {
        const more = await getAccounts(page);

        if (more.length > 0) {
            setAccounts([...accounts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }


    /**
     * Use this to switch search category, we don't need both
     * endpoints
     */
    const switchCategory = (category: 'post' | 'account') => {
        setCategory(category);
        setPage(0);
        setPosts([]);
        setAccounts([]);
        setHasNextPage(true);
    }

    const search = () => {
        const trimmed = searchContent.trim();
        if (trimmed.length === 0) return;
        setSearchContent(trimmed);
        setCategory(category);
        setPage(0);
        setPosts([]);
        setAccounts([]);
        setHasNextPage(true);
        setSearchActive(true);
    }

    // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (searchActive && inView && hasNextPage) {
            if (category === 'post')
                loadMorePosts();
            else
                loadMoreAccounts();
        }
    }, [inView, hasNextPage, posts.length, accounts.length, searchActive]);

    return (
        <div>
            {/* The search bar */}
            <div className='p-5 sm:px-20 bg-white border-b-2 flex'>
                <input onInput={event => setSearchContent((event.target as HTMLInputElement).value)} value={searchContent} className='shadow border w-full py-2 px-3 rounded-full bg-slate-100' type='text' placeholder='Enter keywords here, find posts, and accounts...' />
                <button onClick={search} className='bg-slate-800 hover:bg-slate-950 text-white ml-3 py-2 px-10 rounded-full'>Search</button>
            </div>

            {/* This is where the category can be changed. */}
            <div className='flex sm:w-3/4 sm:mx-auto rounded-lg'>
                <button className='px-5 py-3 me-2 hover:bg-slate-200' style={{ backgroundColor: category === 'post' ? 'white' : undefined, fontWeight: category === 'post' ? 'bold' : undefined }} onClick={() => switchCategory('post')}>Posts</button>
                <button className='px-5 py-3 me-2 hover:bg-slate-200' style={{ backgroundColor: category === 'account' ? 'white' : undefined, fontWeight: category === 'account' ? 'bold' : undefined }} onClick={() => switchCategory('account')}>Accounts</button>
            </div>

            {/* This is where the posts or category are rendered but not both at the same time. */}
            <div className='sm:w-3/4 sm:mx-auto rounded-lg'>
                {
                    category === 'post' &&
                    posts.map(post => {
                        const { postId } = post;
                        return <Post key={postId} showParentPost onFail={id => setPosts(posts.filter(p => p.postId !== id))} postId={postId} className='hover:bg-slate-100' />
                    })
                }

                {

                    category === 'account' &&
                    accounts.map((account) => {
                        return (<Profile key={account.username} username={account.username} />)
                    })
                }

                {/* This is the observed element for infinite scroll */}
                <div className='w-full text-center p-5 bg-white' ref={moreRef}>
                    {!searchActive ? <span className='italic'>Please hit search with at least one character in the field.</span> : hasNextPage ? 'Loading' : 'No more results'}
                </div>
            </div>
        </div>
    )
};

export default Search;