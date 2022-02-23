local TXUI, F, E, I, V, P, G = unpack(select(2, ...))
local PF = TXUI:GetModule("Profiles")

local _G = _G

local detailsProfile =
    "T3ZAVTnss(B5WHdBgG1(47h3I7dsXwjEJTSptLj7ayyAkkAjctrQLKYoEoS(3(vp6MSjLOIN5MKz27cWmosIDxD1vxVRsTUv)2z3gSPS4(0Se8LvRkEkmQmjpkSSiljmnUi)253gehTPEBzsyzsugoUv4)ogg)MKSS4OQA8nRtRIxevhHVoABj9Vj5jLlFgF1IO1rltGxvFBqjSk3hTaGFoaTP63gaVyQXTt1o2aFEvnSqRtkdHL)(0L4kEpSiWhSDdScjvio933Mg)q4IK6K46ugnltQsQdbKkomokEvc(z5fHrzjL10C2wLegLNUocNryuCCcTnwKwfnh2URFUEvAC4IT5ltiic4suww4MSONtkRqkt4YYITBKWQkgitz8sVPOSoejmHzP5puXF46IhzQ26W7llwhMdBlMwbyX21HWJlXviUy98O6W6u4Xt11ac3Jj5W7lJIFiPejaWzcGIlqWEFb8O4ISIsM6H)Nb9xt6Vw4FbuhWJeaJsxUQg(ehXhOorTJ1f0DEY0)AH)RjcaAHQwfTO4PBdME50tLFu6plqt6T3hfNCBWKY0F(L7(V2gTOeycE5Uz4PwjUFLmw1P1z0UhoFr(KGZV8t3gmh2Ilkl20hXCKyMJe1Ce4MLlT7kasdrpKBrtnaJEkDr9kyQ2AnKG6KpJCV3gCssDuAw1l3fKa84P1pFBqXgKvOkuIP1e)jFywxe(0QIBdq2ZQ6O84KQWQKLRHtMQqXYd7M4SKiGZmN4m4pc5nGZty7IFy(cyALWjD4MOs4vioVb4MMpVm5XuIxe3RbpvuMTqYkKwHN(vRiwnIRhzSbWtcjbZlkEyDu5d0MtEGacsTC30Odbgnampc85iHZ(2aILkmTozDywYJm))tP5WrC1bLjBjbW(FByCgk9buOInjKSxdNmrnYtEkEf82KCsMpiEBzjYqVydo)6F1S0SUj5eh)fzr9arToc17m3HzERIwVbukWqYE)mZZFvmZmDKzJf8Wg7Nf2XULd2G4GfN9WXiWcfLXYM7NTfv(s0)8TBa(ZLfBRry3EYb6cZsNZN24tigmujBmSe5W)t66rmpC(Zc7a1GMysJExglyZy2Q4evyxhVI1XvxuKnpI4YLph3OsjKW5BRRbChF(Aqbz5ZHWMa26wTJNrrwxBv39q12nBa98sPdGG2qmeBm8ekg05F7elFBtFBFhFxlpDxdVBV)iBIWVJus0NLsjWUc1chw)8MKWIY0LP5ivhe5wKCF02S6W5lblkBwfHhf2kCrv4kJchv3gC0l3nzBnAeSwbEcWevVIis1PBcfh2MG6kbwPAvPrBt0AqncWFyP1ODcvTvHCtbcyjmmVa0ZaeR6Tv4HGuDQPqw2uOm1uWh6HS2ZbQp(h3Bd(eQdkaMEcOLmUa0AkSdWSfLeBkb0jE(Mo22wW)5Qz6PruxAzg6jhY6KBZ2apmcRJkxMa2Srcg6eclfcBWpXJ990)u3DsBKZa4uwHiBsgCi)ycoQnWN2xFlpm44VUGu4HBtHEdNgsjPFDhnttCC0SnC9TSnTCDCnCB3IATBr2Dk(OBoRCGThiPGwUUMowAAwwog6A(iqSzkOJUNdaBnybCSC9epXe4PTn0nC080mmD9D91XNy1CyIl625Kg6Na1VBI2aQAh3U1eQTiB3eDDErPyxgxaVejXJrq5BO75cC3NJVrZ1t3aEZm13CTYWQr1gRxhLVOIug15yjAEAwADkYS6WycRZTvgjqGfhwPjrsBX3EM0hhvoME2l3z2WbuC)9GhH9GyTqkffKBGZzO(veVUj4Qtp)8XxE5hUja9Ufn0E0vGRRhbCiW2jDnsgbByRkwqCncmsW4yjO1SfP5nycitNKKhUPOsGn2AUh7sy0rGW)X2SAjASBkaT9iGb9KRvqw6esm)j22EaZHHPNHMNHPLLGpa5DmnmCSnmS8809Dm1AynNaCQw6Mw6axNTJUVPGRYcGMgWtP7Az7d8vaJfdnvr)dBxwbhvDIZtO1XtO1XtX6hYZKfbkYr(qqV(AGFv9Cy0IfxMxDJ4a(Mum8HQBOPK0m8QhaVucobCecSzVkbSfsoIuMUGCxkllfiya))Mh3egvjCENKhkJHqbGihEeCdK87oegd(O8TqKhPGbKWQNHyowthYCeay0giYSJLgIpisHTm4HNr9Bse80Sh)4zeDs43Fh)9bHjWzj4DrZdtwppzrpNJWpNcCa8e9ZsEA0W3ZQVPknFzJPto2L4SITGdLCWBTbHbl0daVi49xj6Bu(sYudz0rACh0ocUWjTdlv(2OT22RXnftDHefzjVEfyBEvr2cYqkyQBb4hsifmdi(BAWUgJX)1ycUI9HUadNAvAs2cYGpZA0WXh8(poD2Px3vs(ydBbFLHTGXIeJ(0ORV(SlhAWswqAObVF0fJM2WVAylgSLVJMVP7(H)fJE3PFPP0zvU60zFXLW1UvA6KR)4zN0mdxlwjlpnFppdsb8UlZfxo9dnZsoExt1XFSCJWkTp50rZE)hME27E)EqW9pfyrcoWjH624Jt)WuWP4DWO9n2RU(StdArIwIJrhsWEonU(Y39XtFvtSdXAeOBa9O81TKQO6Ptp9IF61S)p5uGy1LXvEC4OOgTpf(9ObLx1PFxk4OZhDYzthcX6UgFC67U(YpE1vNp6NuqUdEcbsvNF5B)WRdX6Cev3gD49zrlz3RKU6dFk8su)AvRURDucd)Z65fzvyMLaV1AupagB2J6HJDCLgEK(7ATpndh7knq5ipkSm3dT8yFzYiSBOmM7OjWsVN1oFYc6ORpD6OWFcCQOrwqVZPVXborSKklKOxF1d6nAteJqZQVQGUSA(dj37kPz6gseZSVYlZEOJ9EeZnAYAGak9fVHWd00naNu0SC8aVzDudCyVpXCON0qEF31NE60EunDvAMQwcjnZxMzjRDLRHdpDDxvFqpwt335Wc3oYJlD5PHlrUbM)kkOdWnHPN(Xzxp689XjSRbjj5wsV9C3NKOTKl2wxDzHrUQaCERmhDyUytwY91KvCW5i2)G5LfrlI5mRQ4VbNcNLLrBwLgJwNRlQbjXDIFQn6uqMmeeWRypHKXJZH7NSiLspCVyzXChvbHCZX0s(ffrHWkE5vGNYtCXiJGqK08n8TmTWWGWCyvgTifIYg0JatLcqJJUgx7CoZuprouvSGJSJgd4Zh4Xb5ycrcg3nTwYqSTj38hY1hl72CmA5rhzk5fG9(f5va2hezYEgDRettZYk1eIitycNle6jj5pdrjaXJcbxuvHo7YHp0ntf1qe4ltkLzRWwMeh6iGZ3ChI9gaaXHRlwiYvfeIwu5IqYT059Y8hMVio1F4RuY9xt(6hCecQfOwE9gbF5rEkspgCSchPB1MxzGYQKYer887KgX5fvKhIISEufdE5hrOaBdaZ2VIJItDmu8Kr332uVXHMwNT0BSprkFN6y2QIZTV)p9hmMA5UYN9Dhtxoq920z3GfdnwJD9aRV3KnJTfDLwG13)aTgct3ZUY(ai7UumNdn6MbB6kaU7ooz4CGr71Qs1u4wrxht2Dk(TgYKJ2B4H7OnefCNXA76EGtMg)QCeKrf(V9qymDvDmAQTN(by82b0whyW9GSHJ9bO47m42ttNDj27mA3drR3z0Ehc27Wg64p4jZoJ1v7qis)HRm6H1m0)0xxZyyIExPnx9bX8E0eDnZHpC6buJbLG7XEORzDacDpOAEiM0D47mpKaWo7n7dCO0t)KJ(G7U(Sr2ohG5V)PwlZ)oWDNHADa5KESq1nflNCDHYMNs5J5YpRyshRhd4J1dIewI5VPR9T9vKgj0W8jTcC6iJC8yEB2uYsxNkkOBZS49aymnuKIXGC0BhQy9pF7KJ8C0b9yA(oUUo(AEKJuw3g8zWXAnnpnxFqfGHNPTbMTqigOGNUDITULTRgmCDxFpFiQaEoRUDIJURLNh4jUHMMJTHWTmm3ZG)p8sI(h(zYm9tIcZIL0stJPIuIXBlsb5Zj41w9kWJXLRuIdKYKnNw0oNOUy(Uwqfub9JDzyjGvUE6iEQzA747q7rBh2xp0XLWI7fPDtPkxIsrDWCBkQNfLNYqQtj(IzPuDkvHgOtTXLfHnb62w8ykzXGtD5lRARfeEm(uufvBvEyvpLIUlICoyJzufMMRUzujEI1MwAQjeasDA(905cYfEnsmOKtYnWr8RCprdL3qmVLOkyeqpxfOISGQW9Qa8jLPj5lQMGfU8MpE2rI3FEAv9rVVDcmMs8jupLqNqJXdOX45df(YMKYyQljKo)FF6NrxK3BfBAoxr2VnruIFc4YzHzpLcocFX8K6NssYrwS62TsBPBcvs9aLCw1DpNw6xtDmAQA4quFkLXHZk(C6hp7MlGGOIUzcYRCZ40LtlkwKLmRO44667Bl6SAAJBpg2FnsmeIahglff1OJp7Cv15Tne7rEvwAnREtPo2gwT0Ux)gCgpJQB4p9iQw2hxVmQfyXBRQlwVdmbjmieNmsZ32naJbfYtgepnweGQBgfNUyCjv5v45jLVdRgZXxyG1G)P2rtv)8Mt)BxnAAWzxovZ4MtU8YtgDsWnVTidcCQm6M3E55Nm6Aic(lF7hdoETHC9uljmdtLiQ5pOzi6Yj1oKAr944nM4nqi4pZfyOHrtS)zZj)3OOH()44xUJEL5)G(hJ)Hu8zo1(q1YgJOlnexL9W8sDJrJCen8w(KjE(U6EOjelxddlnnLQoT)Nyo4tAuVs4ajPNVD9CUELm(ZKNo7559uI1I08hVp6Zl39gbH5p3qP(3(bfbKJE5oMJR)wxvSxHk01sJVwBDBh4jMd(evQqVv83m5MRd7KU09tcFnkTeSG7byDr9ouubxVo1kEudfowWEpu1zbhdGi9JUhtlLSdev6vha2GoWxUJ1cclukUnwQWFRIGJLO9(zMW(kmCtLOXcBPnvjBIkJQbkIq4HA3VgtGSeRWQm4c2du2v6BKM3cpLUHamTNxKufH18UMvmO8wQVQiFE66RG0phzowAR4i5zJKIkD5GhUo5u0YbDkI8RInMRQ4cMZ8bNttVnTRHL3jo27OQqZ20YhRsTHPVMMPIQI9)eZbFILGXGDLd98jNo)Ko9QOPnnht2krVFmkBl1QdAuaeFXbsdZ81cpRxh8SFTWZ51oq3x7a9ETd0)1oqDTx9iF1Nl6gV6r(QpB0TE1J81E(ullL)0KNq(9ONrDszGHDu1ZmU8)h0PZEEMDWb3QBbBOyUJrvJuabGHmUi0Rvf5zYhTj2wAwM6(gMAUyrtC5wFdXsm2bypkuafqbHboggab0snEa6snSIbNC6SrNDEqyWSrZ(yW4rxhE15F8DNnn8TuXhe(op8WU6KRcAQfac4dpYznjTEMSt5WD5esL)OyW)n4rrzVC3vGHo8nXpZJ4NUq0ioyZumtgka(KrqSe5Ch9bVlOPPLX392VypTCW9wWPV7ItNo7RiwR)Bpw)wrvJ(AHYg)Ar5Ar8xVccE9UccMnccGdvIula4nYQRMzfrW(DZMWrgUcCItJG0y4URILQ4wOse8CkkO51vvsroljr9snkAcMOjFFwcXp3GEf5GZApkmxiQ0g34MDHv2Zym)nnWez2xX5WZE7LtdU5SP)yia)0SWzaQMUUBqE7rltyyvE0M3t0jcTcxtfvbiIIYe2T)M7KPH0CofeiYH4edmUbarLLkbAWUQiZzHczwOMJBmPsfVOqNQ6MLJ2wxMtQLJPPPUUMRLMPHgMFW7pYYJY60r6AhdEp4qnvjMNVarl1n(YzZU8IRP6E326wSlNCUOAsvslkIPSd8e73C3AOdGOAGhd4m5VLc9IGVTlcB8QRVPJjEwAoU6(MAwwgwG(ELIPV)Nyo4tKU53ngkSZZ(hYsOEyhW7kAPR4sVY3sbdn5ESVV4I(QFnXh0WC(JKTyzf0n5oajKyOipMNjuEmwAsAEJRITmCnPiccPEo6cj2rWZ7zL9ajvRS4jUCS4Al(YmGRizpTclm5I0sXxejCz6Yw3fW0CwIPLR7C6IY0xsKIQ04OI)WNoxLS0gcmS5s9noI(BvPJGP9IAlbBIVpjpzT4DyXKB6C5z9L(aPhxa)bPiBDxdalB42h4jMd(elrMjaIILHJgQfPPRx3tBbpB05G9Njxp6ItVz(YJ2uc4B9rYV5jk9pnIMwo66oEoAEU6y)QGTtRJrR23HEUfPuZqZr30goCXg7TPpxumgieZcOoGvKXTjU(26ooU22WHUTUHHOvjy1yICW4Azz64754l0ajAKbaDGzBaQq1TTDSCDywdXxeV22uOn2YnzBxMMVxU4wprzAXCLC2cBWXyirJ5VVbI8WIDfUGosTKbgP96TaZsOInys8gTSVsT3rjf15ODUjrlsu92KDRGJ6BWAIakan1G)6GegJwHiBS8G6a1Wx3deNueIareiIyhhShQ1S8DeuzuiYWeK380DSTCGtxJVxtKVunrgs353ljYWLe589N3ZbZU13liYVZfe5lw3IFtRsIA5x(EbruliYoPVDGQH8LQ543lnY)NQ0ihOUf)VOgj7VGl7w5KF)lnYULq)1wpK9vHXFXLe5xHZIhzOexC93RGY3RGY3RGY)pRckZ)EfugOckDst)V8S8Vo6ZbCGyNTOs4w7Vpfv5B3g5RzDw(2Tl(N9sVOMF3FlQ8IOMk69R2IADyuQpZVdvE5xq(q)DTYm7whMb7L1(fOX2ZX03ZW10XZX1KZRmvGMjG3qUM2wo2U6MyozLjW(pSLPz3YuPuCIxvbj2TqpDk3XG16PTOjFTklZx5QjT)ivBtlZ3UI1SVgW6REHA(dvoM7uH7xtvB(EPy(JEPyuQG)bQkZVH1uHyKwMvmp6eojzIB0ky5I2StbSrWl(UO2uI3S07tcfzEGVMeZsEK8tGVpuC5lZm6QkrCTKqIY0vnhkhVEn7UaDJpHkiq(F6wAKa3wu0KUcfc4V3SXXRIYxcOuWl)1Ja1KWiE5UNwLa)TEfOPKVDxE5oEyq04P1WFWjsq4Nbpf6bHdnzC4)z8HPWBqebgEAwgTSe8sZtRLaIFEDrhKsKvG)farGHMgLHFvzbqUzB9l3TkPmPbURsJx9YDOzELfb)G4eg(mweLvv0za1k4p)nAcwRk5MyXl)vC2OPhaw3lgiDm)YDzflreM8EbrqXtpbFkabHFbVC3BeFVOF5oqc6hE5Vk2uhVN7)SxU7)Kg1FHxxMiGqMUc6auaiVQxNI)zezKKOka5ZRrcaRlNPMYR2h4DapfGnllWZgmdm8aiKUiBbmTK6AqCaPAWUdCCeEdTcc0VUCBIc(pWvheThWHk2e0xxBfQhymbWQMl9Mo0htfW37l8ntAmfaT561rSh4Vm4WwaIIMjty(7iwxCQTlbEbym8I0ElrslhoyXcc(ELXRfNqWoBbj4(pUo5EeVgjF0KT5KQNQ38dc4aHYG8FOZH4j2pJcilOtKYK)(2uKJgoN)3bnbfrIn3tf4L6u7wWYt7L7aOy1HBQ3xv)JB5NGX)xgECSUAEGnmEGwsXPLGXdV8drzTmK0gvjEiLe1Mp(ndXOSNlsX(mjTliMDuGNpUixrMsQAH4DKsfOMF8yObjBrG7b5CvmyFxNVekqduGdRWJK1BjbhsuHwA5X9trL5KWbQDaHxU6cQREuiUPkfZGemk2YKyDT)cP5JcII1XivaQQMeunvTxDRuGAmdofzhXTWrKHGL(mH3y)saRawYzs3oOWc9Ras08Q4JoX0P7rw8I)T658y17a1KpVjSmkDbSyX4vorsP4sZJdiaJdDvATW(hwlaWTRhsfxiK8DAwihs4cEE5BI7)rIBlHNqJf3gem6NORWmX9UkIwKAl82yvXzMo3oynDKr3HlUi0AFA3RuSwGT3zXPNWO)s18XDM0qbqRuSLoJVjmh0nynYnynz0uQUuWl6xC0DG9ay(Vuuuqh(voTFzOSysdDKO2XnnExHx4gnxdtO)ByknFlf5gx3yzbdie2032KUKpcMLSgwUY)eib8JjLlsJbX(3O(HaeHaKqBc)aTtTW73YMQkiicaGgTfv9J3BnuMq2xww(us0gqQymiRO5kl4GGacq408htllYrpobCycy)cug9d7fA0wk8IOLPXHtqVsskXXlRnbDlnco)tXlheaYQLlXBfvWQ7dOhfxT6zmQVmEhzy6AB2uWcro22bFob83oFqeAeLgONdd2E)9f4DYRSSgeQS3TxD6sWOZb2EJkJJYtcVaobUGUPFEwwceeOo7dOG54FyqYFWw077jqexH4ad2KwMwllwccs39aYZJEm6WB5Rx9Cb8IvH)yrgGWfYQQGq0BpqmidyKpmiFl2EdyrpVQiTc4y0mAQadrp9DeCVtklQQNxGg0EZfPLLOzMZqPC(KfIa0ZYPPMm0rle0oF8((INYi7JJZipVEZfrOnGz09xB78nnBQudnFllhINp480h5PdgnGzd2gYkQAetmmD4RbAU0nKCIRNbN50GXrLpuTbVgGrPniKUhAxsi8s)Mc5qZZXZ3N3VFa4fYq)ddk2M1FQo2ypt3uzhsfLVJpFxybOl51uJxTxevw)m6e0jrDiy(ME3Y3rbcqyO5k2XVllkfT6oRaDI6nY3(VAiNSHjlhP72UL90neRFr(FIkxkCE3h1TCS0T4P61mviYDg1)uY8Nq79KcjEN)UK19HbigBzQtWqY(zOB4cetIhCdOSDDA8aNZoAoeFIHwZY77WxkybJZkkw8mMIUSKDpUC0yDzgsomapC802pl2OIt7Zzz0OgvhVVR7JSkZObhvyOGZRwC8L7EFuDjf(qpK0qxC75y1ovnBM6cITGUiCRjaYPso5(WbSzOXNsg2TWrN7se4ag8nSK2UxH9ieZR93IY(5O0pVZHLTfEDJq3KinGsxxNb1zlXGNreauXNGN6ti)T7TT0199nzIFldhMLkj36IuSVhW5FrYc0EYU7jdBd8wXbHrJAqnVbTCeq2E7B3WWxz59S3D5hhTy5E4DS98Si7GAkNOES1WRbljmZdAnoHyF6I56AMEgKQcZgEpdphljhbeWm5f)hsXiNFZvqOpG8Q4O01YMzjmnuXD3DX9txdEHSEp8uMwmYlzh9TSCf(cuxKNiu3hdgzAT1s7z22VvJcgDq4)Gky07RGX0wfP13fPpdc2cyII2J6vBnsjHPcFNfNxXGRlQJlbFMqrOFeKfkapAoPiBhnT6UyIh5TrlNNMpFh7e8j0D9QneXV3eD89CfRVNIosX6)2vuEEA0rF929yHa5yDzQqlBNUMltfEBroLxjae8DR8NGGG2qr40dvS8bUpUDo0ujf2)AjfwTUx6YxpNGoH7tMdAvq2hu7Y6MtbdnsxMLK7ZZdu3Z20tXI(rR0aM01j3bSmv9dp4IKSKKH995PIYfH0nSjycxINaVGHqs)HTzpW6UafOix0(e38nOJoRwUpDhjDpkoAZQI8ITaL(TGZ(7Of2cBlbY2QLK1Z3tZGN(7rh8xH6EfXylvW45i(fIa9YfVdHWAOai6cqcdt(dNKa8me)9faJnv0aKyc4bxYlt5sASnN(LCqCfhHKP1GzqaAzBA(qDSmgF6SPNC5NcPR00Wlg9HZM(oD6xrc8NIh(xTc1w(AEtlFnx53Ja8EmflN(LxmE0SWzNDXPiieLkgIgcit4f4lgeKy9WcVh(XP4)qlxCDzM4NQe(gMUzZmx9NqfLpeVrMYR4Dr7V(g9YPbxID5vb18NPCm3jW7275D92ICdo35RvNq3qIWrrwcazr4KZE7LJ5yXAQRAhWsxLuyxZvHPpaNVpU)0rcwGUj9xd6V60F1eDqBtMYrqbBXWTGnXkL42f5xhlGLi5)8fRdDzzIPKxSl5(pr8dJu3kK39xNg99)dbL8xmQ9C9FpV5NjQ5D)zI6AGrCc4R6o)AX8vBfhRKK5DASPVjRQL23Qv9c63fNVvR2isbZ3qghtTVLR23mMfSFDWw0LvWJQYf)(ePbocRiVJY5nc9Ch2oEy9)egk)fsQr1FT839azH(KQC5FnIk3UPUQ32(j2pbSXsqmmN(ghGzFSTHtY5BcVAfWTb1AUdSAbWPNpb1Sk7RWA5VFduNpl)w2eiOmlWgluJ(6CefVQp(LKfxGfSjcGSqlDdjfhp)dTWCL2Ujh7SGOLC1EfiSODbsIf)KPOuYZUynMv54fd874MmHWXffzyb4fitV3szfgoaxK20hGIEsQI7dbUhR4oAQBVkjNTSeUCNkipBB3nuP76HCejzfASyQ8Mm((0Yk(csMZRmBvJ6PcSKEuZVmM(vTc55AUqdB(r8JB1410LYSb9dvtytxXWnwbyg(NlWgHlaBxP5YXqdPierPowvv)nfYIYqMPOzYOGfKajT68MEuQTpOsRAkOSOc1CxruiAw8UO2)eCRkkBr7FdjWQ9lOjrG1)QqGngKa)hP2NH)Uo39NtU0fyEkBLLufE70v0C1z2rwVrTyJEJRhD2jDepjXoqs8lPOHKyBA5seXmm8D6)5IFIjD010n8SSm6D)0xF7T)p)"

function PF:Details()
    -- Import new profile
    _G.Details:EraseProfile(I.ProfileNames.Default)
    _G.Details:ImportProfile(detailsProfile, I.ProfileNames.Default)

    -- Apply privates, not needed cause done already
    -- self:Details_Private()
end

function PF:Details_Private()
    if not _G.Details then return end

    -- Apply installed profile
    if (I.ProfileNames.Default ~= _G.Details:GetCurrentProfileName()) then
        _G.Details:ApplyProfile(I.ProfileNames.Default)
    end
end
