import { ComponentPropsWithoutRef, MouseEventHandler, useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

import useAccount from './hooks/account';
import timeAgo from './helpers/time-ago';

interface PostProps extends ComponentPropsWithoutRef<"div"> {
    /**
     * Provide only the postId and this should automatically 
     * have all the functionality.
     */
    postId: string;

    /**
     * Whether to show the parent post or not.
     */
    showParentPost?: boolean;

    /**
     * Whether to hide the reply button or not. This is useful when viewing a post
     * and the reply count doesn't update in real-time. 
     */
    hideReplyButton?: boolean;

    /**
     * Whether to hide the controls or not. This is necessary when showing
     * the parent post for a less confusing UI.
     */
    hideControls?: boolean;

    /**
     * This gets called when fetching the post fails.
     */
    onFail?: (postId: string) => void;

    /**
     * A callback function that can be utilized when the post loads.
     */
    onLoadPost?: (state: PostState) => void;
}

/**
 * This describes the state of a post in a single object.
 * You could infer what this means.
 */
export interface PostState { 
    postId:         string
    postParentId:   string | null
    postContent:    string
    postCreatedAt:  string
    userCommonName: string
    username:       string
    likeCount:      number
    replyCount:     number 
    hasLiked:       boolean
}

/**
 * A reusable component that is reliant on the backend to get the state.
 */
function Post({ postId, className='', showParentPost=false, hideReplyButton=false, hideControls=false, onFail, onLoadPost, ...otherProperties }: PostProps) {
    const account = useAccount(); // probably not the best organization but this works for me
    const [ state, setState ] = useState<PostState | null>(null);
    const navigate = useNavigate();

    /**
     * Retrieves the current post by postId and populates
     * the state accordingly.
     */
    const getPost = async () => {
        try {
            const response = await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/view`, { postId }, { withCredentials: true });
            const data = response.data as PostState;
            setState(data);
            onLoadPost && onLoadPost(data);
        } catch { onFail && onFail(postId); }
    }

    /**
     * This toggles the likes of the post and also repopulates 
     * the state by refetching the post itself.
     */
    const toggleLike: MouseEventHandler = async (event) => {
        event.stopPropagation();
        if (state === null) return;
        const action = state.hasLiked ? 'dislike' : 'like';
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/${action}`, { postId }, { withCredentials: true });
        await getPost();
    }

    /**
     * Delete the post, if deleting it is successful, then 
     * call the onDelete callback
     */
    const deletePost: MouseEventHandler = async (event) => {
        event.stopPropagation();
        await axios.post(`${import.meta.env.VITE_BACKEND_URL}/post/delete`, { postId }, { withCredentials: true });
        setState(null);
    }
    
    // we get this post everytime the id changes
    useEffect(() => {
        getPost();
    }, [ postId ]);

    // do not render anything if the state hasn't been fetched yet
    if (state === null) 
        return <></>;

    return (
        <div className={'bg-white border-b-2' + className} onClick={event => { event.stopPropagation(); navigate(`/posts/${state.username}/${state.postId}`)}} { ...otherProperties }>

            {/* The post data, including who posted when, and the content */}
            <div className='px-5 py-3 cursor-pointer'>
                <div className='flex items-center gap-2 whitespace-nowrap' onClick={event => { event.stopPropagation(); navigate(`/profile/${state.username}`) }}>
                    <div className='hover:underline cursor-pointer font-semibold whitespace-nowrap text-ellipsis truncate'>{state.userCommonName}</div>
                    <div className='hover:underline cursor-pointer whitespace-nowrap text-ellipsis truncate'>@{state.username}</div>
                    <div className='text-slate-400'>• {timeAgo(state.postCreatedAt)}</div>
                </div>
                <div className='w-full text-lg'>
                    {state.postContent}
                </div>

                { 
                    // this is the rendering of the parent post, as you can see Post is a recursive component
                    showParentPost && state.postParentId && 
                    <div className='border border-2 border-neutral-300 p-1 mt-2 rounded-lg'>
                        <Post className='border-none' postId={state.postParentId} hideControls={true} />
                    </div>
                }
            </div>

            {/* Inside here are the controls to the post */}
            <div className='w-full flex items-center border-t-2 border-b-2 justify-around' style={{ display: hideControls ? 'none' : undefined }}>
                <button className='grow p-2 text-md hover:bg-slate-100' style={{ fontWeight: state.hasLiked ? 'bold' : undefined }} onClick={toggleLike}>{state.likeCount} likes</button>
                { !hideReplyButton && <button className='grow p-2 text-md hover:bg-slate-100'>{state.replyCount} replies</button> }
                <button className='grow p-2 text-md hover:bg-slate-100' style={{ visibility: account.username !== state.username ? 'hidden' : undefined}} onClick={deletePost}>Delete post</button>
            </div>
        </div>
    );
}

export default Post;