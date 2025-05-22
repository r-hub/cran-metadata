# get_package_directories

    Code
      get_package_directories()
    Output
       [1] "src/contrib"                          
       [2] "bin/macosx/big-sur-arm64/contrib/4.2" 
       [3] "bin/macosx/big-sur-x86_64/contrib/4.3"
       [4] "bin/macosx/big-sur-x86_64/contrib/4.4"
       [5] "bin/macosx/big-sur-x86_64/contrib/4.5"
       [6] "bin/macosx/big-sur-arm64/contrib/4.3" 
       [7] "bin/macosx/big-sur-arm64/contrib/4.4" 
       [8] "bin/macosx/big-sur-arm64/contrib/4.5" 
       [9] "bin/windows/contrib/4.2"              
      [10] "bin/windows/contrib/4.3"              
      [11] "bin/windows/contrib/4.4"              
      [12] "bin/windows/contrib/4.5"              
      [13] "bin/windows/contrib/4.6"              

# update

    Code
      update()
    Message
      i Updating 'src/contrib'.
      i Updating 'bin/macosx/big-sur-arm64/contrib/4.2'.
      i Updating 'bin/macosx/big-sur-x86_64/contrib/4.3'.
      i Updating 'bin/macosx/big-sur-x86_64/contrib/4.4'.
      i Updating 'bin/macosx/big-sur-x86_64/contrib/4.5'.
      i Updating 'bin/macosx/big-sur-arm64/contrib/4.3'.
      i Updating 'bin/macosx/big-sur-arm64/contrib/4.4'.
      i Updating 'bin/macosx/big-sur-arm64/contrib/4.5'.
      i Updating 'bin/windows/contrib/4.2'.
      i Updating 'bin/windows/contrib/4.3'.
      i Updating 'bin/windows/contrib/4.4'.
      i Updating 'bin/windows/contrib/4.5'.
      i Updating 'bin/windows/contrib/4.6'.

# update_dir

    Code
      ret <- update_dir("src/contrib")
    Message
      i Downloading package list from <http://127.0.0.1:<port>//src/contrib>.
      i Parsing metadata from '<tempdir>/<tempfile>/metadata/src/contrib/METADATA2.gz'.
      i Will update 1 package.
      i Downloading 1 package.
      v Downloading 1 package. ... done
      
      i Checking file sizes.
      i Calculating SHA256 hashes.
      i Writing new metadata
      v Metadata successfully updated for 'src/contrib'.

---

    Code
      meta_new[grepl("test", meta_new$file), ]
    Output
      # A tibble: 1 x 6
        file                    size sha                       sysreqs built published
        <chr>                  <int> <chr>                     <chr>   <lgl> <chr>    
      1 test_0.0.0.9000.tar.gz   552 1445e9b41452f795c0a6cbfb~ ""      NA    ""       

---

    Code
      ret <- update_dir("src/contrib")
    Message
      i Downloading package list from <http://127.0.0.1:<port>//src/contrib>.
      i Parsing metadata from '<tempdir>/<tempfile>/metadata/src/contrib/METADATA2.gz'.
      v All packages are up to date.

---

    Code
      ret <- update_dir("src/contrib")
    Message
      i Downloading package list from <http://127.0.0.1:<port>//src/contrib>.
      i Parsing metadata from '<tempdir>/<tempfile>/metadata/src/contrib/METADATA2.gz'.
      i Will update 1 package.
      i Checking file sizes.
      i Calculating SHA256 hashes.
      x Failed to update 1 package: test.
      i Writing new metadata
      v Metadata successfully updated for 'src/contrib'.

---

    Code
      meta_upd[!meta_upd$file %in% meta_new$file, ]
    Output
      # A tibble: 1 x 6
        file                size  sha   sysreqs built published
        <chr>               <chr> <chr> <chr>   <chr> <chr>    
      1 test_0.0.0.1.tar.gz 1     <NA>  ""      <NA>  ""       

