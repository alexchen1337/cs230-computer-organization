.section .text
.global mystrlen
mystrlen:
#static int cppstrlen(const char s tring[]){
#	int i;
#	for (i = 0; string i != '\0'; i++);
#	return i;
#}
	# const char string[]: a0

	li		t0, 0
1:
	add 	t1, a0, t0		#base + index * size
	lb 		t1, (t1)		# string[i]
	beq 	t1, zero, 1f
	addi 	t0, t0, 1
	j 		1b
1:
	mv 		a0, t0
	ret 	a0



# static int cfind(long arr[], int size, long value)
#   {
#	int i;
#	for (i = 0; i < size; +=1){
#		if (arr[i] == value) {
#			return i;
#		}
#	}
#	return -1;
 #  }
	li 		t0, 0
1:
	bge 	t0, a1, 1f
	slli	t1, t0, 3    # index # size
	add		t1, t1 , a0
	ld 		t2, (t1)
	bne 	t2, a2, 2f
	mv 		a0, t0
	ret 	a0
2:
	addi 	t0, t0, 1
	j 		1b
1:
	li 		a0, -1
	ret