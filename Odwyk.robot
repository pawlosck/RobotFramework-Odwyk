*** Setting ***
Library    OperatingSystem
Library    String
Library    Collections
Library    SeleniumLibrary

    
# Test Teardown    SeleniumLibrary.Close Browser
Suite Teardown    SeleniumLibrary.Close All Browsers


*** Test Cases ***
Suite1
    # Listuj Linki     pierwszy_odcinek=1    ostatni_odcinek=50
    # Listuj Linki     pierwszy_odcinek=51    ostatni_odcinek=100
    # Listuj Linki     pierwszy_odcinek=101    ostatni_odcinek=150
    # Listuj Linki     pierwszy_odcinek=151    ostatni_odcinek=200
    # Listuj Linki     pierwszy_odcinek=201    ostatni_odcinek=250
    # Listuj Linki     pierwszy_odcinek=251    ostatni_odcinek=300
    # Listuj Linki     pierwszy_odcinek=301    ostatni_odcinek=350
	# Listuj Linki     pierwszy_odcinek=351    ostatni_odcinek=400
    # Listuj Linki     pierwszy_odcinek=401    ostatni_odcinek=450
    Listuj Linki     pierwszy_odcinek=451
    # Listuj Linki     pierwszy_odcinek=1


    
        
    
*** Keyword ***
Listuj Linki
    [Arguments]    ${pierwszy_odcinek}=1    ${ostatni_odcinek}=${None}
    ${nazwa_pliku}=    Utworz Nazwe Pliku Z Data
    OperatingSystem.Create File    ${nazwa_pliku}        
    # ${nazwa_podcastu}=    BuiltIn.Set Variable    Kwadrans z Podkopem
    ${nazwa_podcastu}=    BuiltIn.Set Variable    Odwyk
    Otworz Strone Podcastu    ${nazwa_podcastu}
    ${ostatni_odcinek}=    BuiltIn.Run Keyword If    '${ostatni_odcinek}'=='${None}'    Pobierz Ilosc Odcinkow    ${nazwa_podcastu}
                    ...                    ELSE    Set Variable    ${ostatni_odcinek}
    BuiltIn.Log    ${ostatni_odcinek}    console=true
    ${lista_odcinkow}=    Utworz Liste Nieparzystych Liczb    ${pierwszy odcinek}    ${ostatni_odcinek}
    :FOR    ${value}    IN  @{lista_odcinkow}
    \    ${nr_i_tytul}=    Pobierz Numer I Tytul Odcinka    ${value}
    \    Otworz Strone Odcinka    ${value}
    \    @{linki}=    Pobierz Linki    
    \    ${opis}=    Pobierz Opis Odcinka
    \    ${adres_odcinka}=    Pobierz Adres Strony
    \    SeleniumLibrary.Go Back
	\    OperatingSystem.Append To File    ${nazwa_pliku}    =====================${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    NR_ODCINKA=${nr_i_tytul[0]}${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    **${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    TYTUL_ODCINKA=${nr_i_tytul[1]}${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    **${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    ADRES_ODCINKA=${adres_odcinka}${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    **${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    URL_ODCINKA_MP3=${linki[0]}${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    **${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    URL_ODCINKA_MP4=${linki[1]}${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    **${\n}
    \    OperatingSystem.Append To File    ${nazwa_pliku}    OPIS_ODCINKA=${opis}${\n}
    SeleniumLibrary.Close Browser
    
Otworz Strone Podcastu
    [Arguments]    ${nazwa_podcastu}=Odwyk
	Open Browser     http://www.odwyk.com
	Click Element    id = crazyPidg
    Click Element	 xpath = //span[@class='hidden-xs'][contains(text(),'Wszystkie programy')]
    Click Element	 xpath = //a[contains(text(),'Program "${nazwa_podcastu}"')]
    ${adres_strony}=    SeleniumLibrary.Get Location
    [Return]        ${adres_strony}

Otworz Strone Odcinka
    [Documentation]    Otwiera ostateczna strone z odcinkiem, na ktorej sa linki do mp3, mp4 i player z filmem
    [Arguments]    ${pasek_odcinka_id}=1
    SeleniumLibrary.Click Element    //*[@id="ui-id-${pasek_odcinka_id}"]
    ${ramka_odcinka_tekst}=    BuiltIn.Evaluate    ${pasek_odcinka_id}+1
    SeleniumLibrary.Click Element    //*[@id="ui-id-${ramka_odcinka_tekst}"]//a[contains(text(),'Link')]
    

Pobierz Linki
    ${xpath_link_mp3}=    BuiltIn.Set Variable    //div[@class='superContent']//div[@class='meta right']/span[3]/a
    ${xpath_link_mp4}=    BuiltIn.Set Variable    //div[@class='superContent']//div[@class='meta right']/span[2]/a
    
    ${status_mp3}=    Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    ${xpath_link_mp3}
    ${status_mp4}=    Run Keyword And Ignore Error    SeleniumLibrary.Page Should Contain Element    ${xpath_link_mp4}
    
    Log    status_mp3: ${status_mp3}    console=true
    Log    status_mp4: ${status_mp4}    console=true
    
    ${link_mp3}=    BuiltIn.Run Keyword If    '${status_mp3[0]}' == 'PASS'    SeleniumLibrary.Get Element Attribute    ${xpath_link_mp3}    href
             ...             ELSE IF                   '${status_mp3[0]}' == 'FAIL'    BuiltIn.Set Variable    ${None}    
    ${link_mp4}=    BuiltIn.Run Keyword If    '${status_mp4[0]}' == 'PASS'    SeleniumLibrary.Get Element Attribute    ${xpath_link_mp4}    href
             ...             ELSE IF                   '${status_mp4[0]}' == 'FAIL'    BuiltIn.Set Variable    ${None}
    
    ${linki}=    BuiltIn.Create List    ${link_mp3}    ${link_mp4}
    
    Log    link_mp3: ${link_mp3}    console=true
    Log    link_mp4: ${link_mp4}    console=true
    
    [Return]    ${linki}
    
    
    
   
Pobierz Ilosc Odcinkow
    [Arguments]    ${nazwa_podcastu}
    ${tytul}=    SeleniumLibrary.Get Text    //h2[@class='superTitle']
    BuiltIn.Should Be Equal    ${tytul}    Wszystkie odcinki programu "${nazwa_podcastu}"    
    ${ilosc_odcinkow}=    SeleniumLibrary.Get Element Count    //h3[@role='tab']
    [Return]    ${ilosc_odcinkow}
    # [Return]    3
    
    
Utworz Liste Nieparzystych Liczb
    [Documentation]    ${min_liczba}=pierwszy odcinek, ktory ma zostac pobrany. Na ogol jest to pierwszy odcinek, czyli liczba 1.
    ...    Wyjatkiem jest Odwyk, gdyz ma za duzo odcinkow i brakuje RAMu. Max co jest w stanie przetrawic, to niecale 100 odcinkow. Bezpieczna wartosc, to ok 50 odcinkow za jednym uruchomieniem.
    ...    ${max_liczba} - ostatni odcinek jaki ma byc sciagniety
    [Arguments]    ${min_liczba}    ${max_liczba}

    # ${min_liczba}=    BuiltIn.Evaluate    ${max_liczba} - ${min_liczba}
    # ${max_liczba}=    BuiltIn.Evaluate    ${max_liczba} - ${max_liczba}
    # ${max_liczba}=    BuiltIn.Evaluate    ${max_liczba} + 1

    Log    ${min_liczba}    console=true
    Log    ${max_liczba}    console=true  
    @{nieparzyste_liczby}=    BuiltIn.Create List
    :FOR    ${value}    IN RANGE    ${min_liczba}    ${max_liczba}+1
    \    ${liczby_parzyste}=    BuiltIn.Evaluate    ${value} * 2
    \    ${wynik}=    BuiltIn.Evaluate    ${liczby_parzyste} - 1
    \    Collections.Append To List    ${nieparzyste_liczby}    ${wynik}
    # Collections.Reverse List    ${nieparzyste_liczby}
    # Log List    ${nieparzyste_liczby}
    [Return]    @{nieparzyste_liczby}

Pobierz Numer I Tytul Odcinka
    [Arguments]    ${pasek_odcinka_id}
    ${tytul_i_numer_odcinka}=    SeleniumLibrary.Get Text    //*[@id="ui-id-${pasek_odcinka_id}"]
    @{tytul_i_numer_odcinka}=    String.Split String    ${tytul_i_numer_odcinka}    .${SPACE}    max_split=1
    Log    tytul_i_numer_odcinka: ${tytul_i_numer_odcinka}    console=true
    [Return]    ${tytul_i_numer_odcinka}
    
Pobierz Opis Odcinka
    [Documentation]    Pobiera opis odcinka ze strony odcinka, a nie z listy odcinkow
    ${opis_odcinka}=    SeleniumLibrary.Get Text    //div[@class='superContent']//div[contains(@class,'info')]
    Log    opis_odcinka: ${opis_odcinka}    console=true
    [Return]    ${opis_odcinka}
    
Utworz Nazwe Pliku Z Data
    [Arguments]    ${przedrostek_nazwy_pliku}=podcast
    ${rok}=    BuiltIn.Get Time    year
    ${miesiac}=    BuiltIn.Get Time    month
    ${dzien}=    BuiltIn.Get Time    day
    ${godzina}=    BuiltIn.Get Time    hour
    ${minuta}=    BuiltIn.Get Time    min
    ${sekunda}=    BuiltIn.Get Time    sec
    
    ${nazwa_pliku}=    BuiltIn.Set Variable    ${przedrostek_nazwy_pliku}_${rok}-${miesiac}-${dzien}_${godzina}-${minuta}-${sekunda}
    
    Log    Nazwa Pliku: ${nazwa_pliku}    console=true
    
    [Return]    ${nazwa_pliku}
    
Pobierz Adres Strony
    ${adres_strony}=    SeleniumLibrary.Get Location
    Log     Adres strony: ${adres_strony}    console=true
    [Return]    ${adres_strony}