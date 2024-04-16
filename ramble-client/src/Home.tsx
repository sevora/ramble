import { FC, useEffect, useState } from 'react';
import { useInView } from 'react-intersection-observer';
import axios from 'axios';

import Post from './Post';

/**
 * This is where the posts are, by following or trending.
 */
const Home: FC = () => {
    const [draft, setDraft] = useState<string>('');

    const [posts, setPosts] = useState<{ postId: string }[]>([]);

    const [category, setCategory] = useState<'following' | 'trending'>('following');
    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const [moreRef, inView ] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    /**
     * Use this to get the posts at category and page
     * @param category the category of the post
     * @param page the current page
     * @returns the postIds in an array
     */
    const getPosts = async (category: 'following' | 'trending', page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { category, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * Load category resets the page state. Even if the category retains,
     * this will still have a significant effect due to the useEffect of setHasNextPage.
     */
    const loadCategory = (category: 'following' | 'trending') => {
        setCategory(category);
        setPage(0);
        setPosts([]);
        setHasNextPage(true);
    }

    /**
     * This is the logic to load more posts through
     * infinite scrolling. Had wasted time figuring out a lot of things here.
     */
    const loadMorePosts = async () => {
        const more = await getPosts(category, page);
    
        if (more.length > 0) {
            setPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

    /**
     * 
     */
    const createPost = async () => {
        // validate draft first
        if (draft.length === 0 || draft.length > 200) return;
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/new`, { content: draft }, { withCredentials: true });
        
        setDraft('');
        loadCategory(category);
    }

    // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (inView && hasNextPage) 
            loadMorePosts();
    }, [ inView, hasNextPage, posts.length ]);

    return (
        <div className='sm:px-2 sm:w-3/4 sm:mx-auto rounded-lg'>
            <div className='flex'>
                <button className='px-5 py-3 me-2 hover:bg-slate-200' style={{ backgroundColor: category === 'following' ? 'white' : undefined, fontWeight: category === 'following' ? 'bold' : undefined }} onClick={() => loadCategory('following')}>Following</button>
                <button className='px-5 py-3 me-2 hover:bg-slate-200' style={{ backgroundColor: category === 'trending' ? 'white' : undefined, fontWeight: category === 'trending' ? 'bold' : undefined }} onClick={() => loadCategory('trending')}>Global</button>
            </div>
            <div className='bg-white rounded-tl-none rounded-lg'>  
                {/* This is where the area to create a post is */}
                <div className='p-3 border-b-2'>
                    <textarea value={draft} onInput={event => setDraft((event.target as any).value)} rows={4} maxLength={200} minLength={1} className="block p-2.5 w-full rounded-lg border border-gray-300 focus:ring-neutral-100" placeholder="Write your thoughts here..."></textarea>
                    <button onClick={createPost} className='mt-2 w-full ml-auto bg-slate-800 hover:bg-slate-950 text-white px-9 py-2 rounded-full'>Post</button>
                </div> 
                {/* This is where the posts are rendered */}
                { posts.map(post => {
                    const { postId } = post;
                    return <Post key={postId} showParent onFail={id => setPosts(posts.filter(p => p.postId !== id))} postId={postId} className='hover:bg-slate-100' />
                }) }
                <div className='w-full text-center p-5' ref={moreRef}>{hasNextPage ? 'Loading' : 'No more posts'}</div>
            </div>
        </div>
    )
};

export default Home;