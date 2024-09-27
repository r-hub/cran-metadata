# parse_file_name

    Code
      parse_file_name(c("package1_1.0.0.tar.gz", "package2_1.0.1.tgz",
        "package3_1.0.2.zip"))
    Output
      $package
      [1] "package1" "package2" "package3"
      
      $version
      [1] '1.0.0' '1.0.1' '1.0.2'
      

# parse_package_list

    Code
      parse_package_list("src/contrib")
    Message
      i Downloading package list from <http://127.0.0.1:<port>//src/contrib>.
    Output
      # A tibble: 88 x 3
         file                      package      version   
         <chr>                     <chr>        <pckg_vrs>
       1 A3_1.0.0.tar.gz           A3           1.0.0     
       2 AATtools_0.0.3.tar.gz     AATtools     0.0.3     
       3 ABACUS_1.0.0.tar.gz       ABACUS       1.0.0     
       4 ABC.RAP_0.9.0.tar.gz      ABC.RAP      0.9.0     
       5 ABCanalysis_1.2.1.tar.gz  ABCanalysis  1.2.1     
       6 ABCoptim_0.15.0.tar.gz    ABCoptim     0.15.0    
       7 ABCp2_1.2.tar.gz          ABCp2        1.2       
       8 ABHgenotypeR_1.0.1.tar.gz ABHgenotypeR 1.0.1     
       9 ABM_0.4.1.tar.gz          ABM          0.4.1     
      10 ABPS_0.3.tar.gz           ABPS         0.3       
      # i 78 more rows

# parse_metadata_file

    Code
      parse_metadata_file("src/contrib")
    Message
      i Parsing metadata from 'fixtures/metadata/src/contrib/METADATA2.gz'.
    Output
      # A tibble: 87 x 6
         file                         size sha                 sysreqs built published
         <chr>                       <int> <chr>               <chr>   <lgl> <chr>    
       1 A3_1.0.0.tar.gz             42810 9c99d5ee74122d38a5~ ""      NA    2015-08-~
       2 AATtools_0.0.3.tar.gz      252641 89d64a7ee0b8057475~ ""      NA    2024-08-~
       3 ABACUS_1.0.0.tar.gz         84194 31b4292097ffd7db14~ ""      NA    2019-09-~
       4 ABC.RAP_0.9.0.tar.gz      4769661 b3d77017c620f48488~ "GNU m~ NA    2016-10-~
       5 ABCanalysis_1.2.1.tar.gz    23436 91e3b8f19b291ec7d3~ ""      NA    2017-03-~
       6 ABCoptim_0.15.0.tar.gz      13482 8bd894574dd5376eaf~ ""      NA    2017-11-~
       7 ABCp2_1.2.tar.gz             7293 7d593601836835b284~ ""      NA    2016-02-~
       8 ABHgenotypeR_1.0.1.tar.gz  100729 14c419abc4f717ec05~ ""      NA    2016-02-~
       9 ABM_0.4.1.tar.gz            48025 57b9dd43e443895a71~ ""      NA    2024-03-~
      10 ABPS_0.3.tar.gz            108733 940ac727fab90ebb81~ ""      NA    2018-10-~
      # i 77 more rows

---

    Code
      parse_metadata_file("src/contrib")
    Message
      ! Metadata file does not exist: '<tempdir>/<tempfile>/metadata/src/contrib/METADATA2.gz'.
    Output
      # A tibble: 0 x 6
      # i 6 variables: file <chr>, size <int>, sha <chr>, sysreqs <chr>, built <chr>,
      #   published <chr>

# get_state

    Code
      get_state("src/contrib")
    Message
      i Downloading package list from <http://127.0.0.1:<port>//src/contrib>.
      i Parsing metadata from 'fixtures/metadata/src/contrib/METADATA2.gz'.
    Output
      $old
      # A tibble: 87 x 6
         file                         size sha                 sysreqs built published
         <chr>                       <int> <chr>               <chr>   <lgl> <chr>    
       1 A3_1.0.0.tar.gz             42810 9c99d5ee74122d38a5~ ""      NA    2015-08-~
       2 AATtools_0.0.3.tar.gz      252641 89d64a7ee0b8057475~ ""      NA    2024-08-~
       3 ABACUS_1.0.0.tar.gz         84194 31b4292097ffd7db14~ ""      NA    2019-09-~
       4 ABC.RAP_0.9.0.tar.gz      4769661 b3d77017c620f48488~ "GNU m~ NA    2016-10-~
       5 ABCanalysis_1.2.1.tar.gz    23436 91e3b8f19b291ec7d3~ ""      NA    2017-03-~
       6 ABCoptim_0.15.0.tar.gz      13482 8bd894574dd5376eaf~ ""      NA    2017-11-~
       7 ABCp2_1.2.tar.gz             7293 7d593601836835b284~ ""      NA    2016-02-~
       8 ABHgenotypeR_1.0.1.tar.gz  100729 14c419abc4f717ec05~ ""      NA    2016-02-~
       9 ABM_0.4.1.tar.gz            48025 57b9dd43e443895a71~ ""      NA    2024-03-~
      10 ABPS_0.3.tar.gz            108733 940ac727fab90ebb81~ ""      NA    2018-10-~
      # i 77 more rows
      
      $new
      # A tibble: 88 x 3
         file                      package      version   
         <chr>                     <chr>        <pckg_vrs>
       1 A3_1.0.0.tar.gz           A3           1.0.0     
       2 AATtools_0.0.3.tar.gz     AATtools     0.0.3     
       3 ABACUS_1.0.0.tar.gz       ABACUS       1.0.0     
       4 ABC.RAP_0.9.0.tar.gz      ABC.RAP      0.9.0     
       5 ABCanalysis_1.2.1.tar.gz  ABCanalysis  1.2.1     
       6 ABCoptim_0.15.0.tar.gz    ABCoptim     0.15.0    
       7 ABCp2_1.2.tar.gz          ABCp2        1.2       
       8 ABHgenotypeR_1.0.1.tar.gz ABHgenotypeR 1.0.1     
       9 ABM_0.4.1.tar.gz          ABM          0.4.1     
      10 ABPS_0.3.tar.gz           ABPS         0.3       
      # i 78 more rows
      
      $missing
      # A tibble: 1 x 3
        file                   package version   
        <chr>                  <chr>   <pckg_vrs>
      1 test_0.0.0.9000.tar.gz test    0.0.0.9000
      

