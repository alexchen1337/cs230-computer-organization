.section .text
.global getj
getj:
    #struct MyStruct *ms : a0
    lb      a0, 4(a0)
    ret

.global setj
setj:
    #struct MyStruct *ms : a0
    #int k : a1

    sb      a1, 4(a0)
    