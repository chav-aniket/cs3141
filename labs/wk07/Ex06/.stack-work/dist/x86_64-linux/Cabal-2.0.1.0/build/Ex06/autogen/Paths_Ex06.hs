{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_Ex06 (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [1,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/bin"
libdir     = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/lib/x86_64-linux-ghc-8.2.2/Ex06-1.0-1BLMHbiOPrCEntQYlwyBHS-Ex06"
dynlibdir  = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/lib/x86_64-linux-ghc-8.2.2"
datadir    = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/share/x86_64-linux-ghc-8.2.2/Ex06-1.0"
libexecdir = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/libexec/x86_64-linux-ghc-8.2.2/Ex06-1.0"
sysconfdir = "/mnt/w/uni/csRemote/cs3141/labs/wk07/Ex06/.stack-work/install/x86_64-linux/39fc893a0919eadadc58309c97e060fe0abf2b15b2d7a70b6f7d3569e857c565/8.2.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "Ex06_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "Ex06_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "Ex06_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "Ex06_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "Ex06_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "Ex06_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
