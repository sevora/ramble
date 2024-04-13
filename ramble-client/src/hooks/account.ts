import { create } from 'zustand';

interface AccountState {
    username: string;
    userCommonName: string;
    isLoggedIn: boolean;

    setUsername: (username: string) => void;
    setUserCommonName: (userCommonName: string) => void;
    setIsLoggedIn: (isLoggedIn: boolean) => void;
}

/**
 * This hook is for managing account state
 */
const useAccount = create<AccountState>()(set => ({
  username: '',
  userCommonName: '',
  isLoggedIn: false,
  
  setUsername: (username) => set({ username }),
  setUserCommonName: (userCommonName) => set({ userCommonName }),
  setIsLoggedIn: (isLoggedIn) => set({ isLoggedIn }),
}));

export default useAccount;