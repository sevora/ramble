import { FC, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useInView } from 'react-intersection-observer';
import axios from 'axios';

import Post, { PostState } from './Post';

/**
 * 
 * @returns 
 */
const ViewPost: FC = () => {
    const { username: urlUsername, postId: parentPostId } = useParams<{ username: string, postId: string }>();
    const navigate = useNavigate();

    const [draft, setDraft] = useState<string>('');

    const [posts, setChildrenPosts] = useState<{ postId: string }[]>([]);

    const [page, setPage] = useState<number>(0);
    const [hasNextPage, setHasNextPage] = useState<boolean>(true);

    const [moreRef, inView] = useInView({ root: document.querySelector('#dashboard-outlet'), threshold: 1.0 });

    const [parentPostError, setParentPostError] = useState<boolean>(false);

    /**
     * Essentially the replies,
     */
    const getPosts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { parentId: parentPostId, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * 
     * @returns 
     */
    const loadMorePosts = async () => {
        const more = await getPosts(page);

        if (more.length > 0) {
            setChildrenPosts([...posts, ...more]);
            setPage(page + 1);
        } else {
            setHasNextPage(false);
        }
    }

    const reloadPosts = () => {
        setPage(0);
        setChildrenPosts([]);
        setHasNextPage(true);
    }

    /**
     * 
     */
    const createPost = async () => {
        // validate draft first
        if (draft.length === 0 || draft.length > 200) return;
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/new`, { parentId: parentPostId, content: draft }, { withCredentials: true });
            setDraft('');
            reloadPosts();
        } catch {
            setParentPostError(true);
        }
    }

    const ensureURL = (post: PostState) => {
        if (post.username === urlUsername) return;
        navigate(`/posts/${post.username}/${post.postId}`);
    }

    //
    useEffect(() => {
        reloadPosts();
    }, [parentPostId]);

    // when the next button is inView (initially it is) we load more posts
    useEffect(() => {
        if (inView && hasNextPage)
            loadMorePosts();
    }, [inView, hasNextPage, posts.length]);

    return (
        <div className='sm:px-2 sm:w-3/4 sm:mx-auto rounded-lg'>
            {/*  */}
            {parentPostError && <div className='bg-white p-3 border-b-2 font-semibold text-lg'>Oops! Post not found!</div>}

            {/*  */}
            <Post postId={parentPostId!} onFail={() => setParentPostError(true)} onLoadPost={ensureURL} hideReplyButton />

            <div className='mx-auto'>
                {/*  */}
                <div className='p-3 border-b-2 bg-white'>
                    <textarea value={draft} onInput={event => setDraft((event.target as any).value)} rows={4} maxLength={200} minLength={1} className="block p-2.5 w-full rounded-lg border border-gray-300 focus:ring-neutral-100" placeholder="Write your reply here..."></textarea>
                    <button onClick={createPost} className='mt-2 w-full ml-auto bg-slate-800 hover:bg-slate-950 text-white px-9 py-2 rounded-full'>Post</button>
                </div>

                {/*  */}
                <div>
                    {
                        posts.map(child => {
                            return <Post key={child.postId} postId={child.postId} onFail={id => setChildrenPosts(posts.filter(p => p.postId !== id))} />
                        })
                    }
                    <div className='w-full text-center p-5 bg-white' ref={moreRef}>{hasNextPage ? 'Loading' : 'No more posts'}</div>
                </div>
            </div>
        </div>
    );
};

export default ViewPost;