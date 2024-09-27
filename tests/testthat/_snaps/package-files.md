# get_desc_data_tar

    Code
      dsc <- get_desc_data_tar(path, "test")
      dsc
    Output
       [1] "Package: test"                                                                            
       [2] "Title: What the Package Does (One Line, Title Case)"                                      
       [3] "Version: 0.0.0.9000"                                                                      
       [4] "Authors@R: "                                                                              
       [5] "    person(\"First\", \"Last\", , \"first.last@example.com\", role = c(\"aut\", \"cre\"),"
       [6] "           comment = c(ORCID = \"YOUR-ORCID-ID\"))"                                       
       [7] "Description: What the package does (one paragraph)."                                      
       [8] "License: `use_mit_license()`, `use_gpl3_license()` or friends to pick a"                  
       [9] "        license"                                                                          
      [10] "Encoding: UTF-8"                                                                          
      [11] "Roxygen: list(markdown = TRUE)"                                                           
      [12] "RoxygenNote: 7.3.2"                                                                       
      [13] "NeedsCompilation: no"                                                                     
      [14] "Packaged: 2024-09-27 08:30:11 UTC; gaborcsardi"                                           
      [15] "Author: First Last [aut, cre] (YOUR-ORCID-ID)"                                            
      [16] "Maintainer: First Last <first.last@example.com>"                                          

# get_desc_data_zip

    Code
      get_desc_data_zip(path, "foobar")
    Output
       [1] "Package: foobar"                                         
       [2] "Title: Foobar Package"                                   
       [3] "Version: 1.0.0"                                          
       [4] "Author: Gabor Csardi"                                    
       [5] "Maintainer: Gabor Csardi <csardi.gabor@gmail.com>"       
       [6] "Description: Just a package to use in test cases."       
       [7] "License: MIT + file LICENSE"                             
       [8] "LazyData: true"                                          
       [9] "URL: https://github.com/gaborcsardi/foobar"              
      [10] "BugReports: https://github.com/gaborcsardi/foobar/issues"
      [11] "RoxygenNote: 6.0.1"                                      
      [12] "Suggests: testthat"                                      
      [13] "NeedsCompilation: no"                                    
      [14] "Packaged: 2017-12-25 19:18:10 UTC; gaborcsardi"          
      [15] "Built: R 3.4.3; ; 2017-12-25 19:19:13 UTC; unix"         

# get_desc_data

    Code
      get_desc_data(paths)
    Output
      # A tibble: 5 x 5
        file                            package sysreqs built                published
        <chr>                           <chr>   <chr>   <chr>                <chr>    
      1 fixtures/test_0.0.0.9000.tar.gz test    ""      ""                   ""       
      2 fixtures/test_0.0.0.9000.tgz    test    ""      "R 4.4.1; ; 2024-09~ ""       
      3 fixtures/foobar_1.0.0.zip       foobar  ""      "R 3.4.3; ; 2017-12~ ""       
      4 fixtures/foobar_1.0.1.zip       foobar  <NA>     <NA>                <NA>     
      5 fixtures/foobar_1.0.2.zip       foobar  <NA>     <NA>                <NA>     

