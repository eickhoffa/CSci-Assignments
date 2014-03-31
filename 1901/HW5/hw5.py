####CSci 1901 Spring 2012
###HW 5 Python TEMPLATE
# =========
####Author:  Adam Eickhoff
####ID #:    4088090
####Lab Section: 5


####################
# Problem 2
def factorial(a):
  result = 1.0
  for i in range(a):
    result = result * (a - i)
  return result

def find_e(n):
  result = 0.0
  if n == 0:
    return 1
  for i in range(n+1):
    result += 1.0/factorial(i)
  return result

# Test cases
print find_e(0)
# should return 1
print find_e(2)
# should return 2.5
print find_e(10)
# should return (about) 2.7182818011463845
print find_e(256)
# should return (about) 2.7182818284590455


#########################
# Problem 3a
def compareAvg(rA, rB):  #Goes through and determines the count of all the numbers
  results = []           #on the lists, then divides them by how many there are
  winner = []            #and then returns the winner with the winning number
  acnt = []
  bcnt = []
  acount = 0
  bcount = 0

  for i in range(len(rA)):
    acnt = acnt + rA[i]
    bcnt = bcnt + rB[i]
  for i in range(len(acnt)):
    acount = acount + acnt[i]
  for i in range(len(bcnt)):
    bcount = bcount + bcnt[i]
  
  acount = acount / (len(acnt) * 1.0)
  bcount = bcount / (len(acnt) * 1.0)

  if acnt == bcnt:
    winner = "T"
  elif acnt < bcnt:
    winner = "rA"
  elif acnt > bcnt:
    winner = "rB"

  results.append(winner)

  if acnt < bcnt:
    results.append(acount)
  elif bcnt < acnt:
    results.append(bcount)

  return results


def weekDayAvg(rA, rB):
  results = []
  for i in range(len(rA[0])):
    aDaySum = 0.0
    bDaySum = 0.0
    aDayAvg = 0.0
    bDayAvg = 0.0
    for j in range(len(rA)):
      aDaySum += rA[j][i]
      bDaySum += rB[j][i]
    aDayAvg = aDaySum / len(rA)
    bDayAvg = bDaySum / len(rB)
    if aDayAvg > bDayAvg:
      results.append(["rB"])
    elif aDayAvg < bDayAvg:
      results.append(["rA"])
    else:
      results.append(["T"])
  return results
    



#Test cases
print compareAvg([[20, 10, 13, 6, 20], [14, 5, 8, 10, 23], [15, 13, 6, 19, 3], [12, 18, 16, 4, 10]], [[21, 11, 14, 6, 20], [15, 6, 8, 11, 23], [15, 14, 7, 19, 4], [13, 18, 17, 8, 10]])
# should return [rA, 12.25]
print compareAvg([[6, 7, 8, 9, 10]], [[1, 2, 3, 4, 5]])
# should return [rB, 3.0]
print compareAvg([[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]], [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10]])
# should return [T]
print compareAvg([[10, 20, 30, 40], [10]], [[1, 2, 3], [4, 5, 6]])
# should return [rB, 4.2]
print compareAvg([[200], [100]], [[300], [100]])
# should return [rA, 150.0]

print weekDayAvg([[20, 10, 13, 6, 20], [14, 5, 8, 10, 23], [15, 13, 6, 19, 3], [12, 18, 16, 4, 10]], [[21, 11, 11, 6, 20], [15, 6, 8, 10, 23], [15, 14, 7, 19, 4], [13, 18, 12, 4, 10]])
# should return  [rA, rA, rB, T, rA]
print weekDayAvg([[20, 10, 13, 6, 20], [14, 5, 8, 10, 23], [15, 13, 6, 19, 3], [12, 18, 16, 4, 10]], [[20, 10, 13, 6, 20], [14, 5, 8, 10, 23], [15, 13, 6, 19, 3], [12, 18, 16, 4, 10]])
# should return [T, T, T, T, T]
print weekDayAvg([[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15], [16, 17, 18, 19, 20]], [[21, 22, 23, 24, 25], [26, 27, 28, 29, 30], [31, 32, 33, 34, 35], [36, 37, 38, 39, 40]])
# should return [rA, rA, rA, rA, rA]
print weekDayAvg([[1, 10, 15, 10, 11], [10, 39, 28, 36, 13], [1, 18, 49, 27, 53], [29, 19, 30, 28, 17]], [[19, 1, 27, 48, 16], [19, 37, 53, 2, 1], [27, 38, 15, 10, 7], [10, 38, 2, 6, 70]])
# should return [rA, rA, rB, rB, T]
print weekDayAvg([[21, 22, 23, 24, 25], [26, 27, 28, 29, 30], [31, 32, 33, 34, 35], [36, 37, 38, 39, 40]], [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15], [16, 17, 18, 19, 20]])
# should return [rB, rB, rB, rB, rB]








