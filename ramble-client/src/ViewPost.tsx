import { FC, useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import { useInView } from 'react-intersection-observer';
import axios from 'axios';

import Post, { PostState } from './Post';

/**
 * This is a component to view a single post with
 * its replies down below.
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
     * Gets the posts under the parent post. In essence,
     * this gets the replies.
     */
    const getPosts = async (page: number) => {
        const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/list`, { parentId: parentPostId, page }, { withCredentials: true });
        return response.data.posts as { postId: string }[];
    }

    /**
     * Loads more replies.
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

    /**
     * This is used to cause a reload on the replies.
     */
    const reloadPosts = () => {
        setPage(0);
        setChildrenPosts([]);
        setHasNextPage(true);
    }

    /**
     * This is used to create a post.
     */
    const createPost = async () => {
        // validate draft first
        if (draft.length === 0 || draft.length > 200) return;
        try {
            await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/new`, { parentId: parentPostId, content: draft }, { withCredentials: true });
            setDraft('');
            reloadPosts();
        } catch {
            // this was added here to notify if the user can't comment 
            // because the parent post was deleted
            setParentPostError(true);
        }
    }

    /**
     * The username being a part of the URL is an illusion.
     * This is simply to make it easier to identify who posted
     * what based from the URL only.
     */
    const ensureURL = (post: PostState) => {
        if (post.username === urlUsername) return;
        navigate(`/posts/${post.username}/${post.postId}`);
    }

    // when the parent post changes so should its children
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
            {/* This is the error message for the missing parent. */}
            {parentPostError && <div className='bg-white p-3 border-b-2 font-semibold text-lg'>Oops! Post not found!</div>}

            {/* The parent post  */}
            <Post postId={parentPostId!} onFail={() => setParentPostError(true)} onLoadPost={ensureURL} hideReplyButton />

            <div className='mx-auto'>
                {/* The reply box */}
                <div className='p-3 border-b-2 bg-white'>
                    <textarea value={draft} onInput={event => setDraft((event.target as any).value)} rows={4} maxLength={200} minLength={1} className="block p-2.5 w-full rounded-lg border border-gray-300 focus:ring-neutral-100" placeholder="Write your reply here..."></textarea>
                    <button onClick={createPost} className='mt-2 w-full ml-auto bg-slate-800 hover:bg-slate-950 text-white px-9 py-2 rounded-full'>Post</button>
                </div>

                {/* This is where the replies are rendered */}
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