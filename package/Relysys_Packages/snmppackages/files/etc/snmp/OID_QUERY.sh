#!/bin/ash -f

PLACE=".1.3.6.1.4.1.38151"
REQ="$2"    # Requested OID

#
#  GETNEXT requests - determine next valid instance
#

if [ "$1" = "-n" ]; then
  case "$REQ" in
    $PLACE|             \
    $PLACE.0|           \
    $PLACE.0.*|         \
    $PLACE.1)           RET=$PLACE.1.1.0;;     # netSnmpPassString.0
    $PLACE.1.0|         \
    $PLACE.1.0.*|       \
    $PLACE.1.1)         RET=$PLACE.1.1.0 ;; 
    $PLACE.1.1.*|       \
    $PLACE.1.2)         RET=$PLACE.1.2.0 ;; 
    $PLACE.1.2.*|       \
    $PLACE.1.3)         RET=$PLACE.1.3.0 ;; 
    $PLACE.1.3.*|       \
    $PLACE.1.4)         RET=$PLACE.1.4.0 ;; 
    $PLACE.1.4.*|       \
    $PLACE.1.5)         RET=$PLACE.1.5.0 ;;
    $PLACE.1.5.*|       \
    $PLACE.1.6)         RET=$PLACE.1.6.0 ;;
    $PLACE.1.6.*|       \
    $PLACE.1.7)         RET=$PLACE.1.7.0 ;;
    $PLACE.1.7.*|       \
    $PLACE.1.8)         RET=$PLACE.1.8.0 ;;
    $PLACE.1.8.*|       \
    $PLACE.1.9)         RET=$PLACE.1.9.0 ;;
    $PLACE.1.9.*|       \
    $PLACE.1.10)         RET=$PLACE.1.10.0 ;;
    $PLACE.1.10.*|       \
    $PLACE.1.11)         RET=$PLACE.1.11.0 ;; 
    $PLACE.1.11.*|       \
    $PLACE.1.12)         RET=$PLACE.1.12.0 ;; 
    $PLACE.1.12.*|       \
    $PLACE.1.13)         RET=$PLACE.1.13.0 ;; 
    $PLACE.1.13.*|       \
    $PLACE.1.14)         RET=$PLACE.1.14.0 ;; 
    $PLACE.1.14.*|       \
    $PLACE.1.15)         RET=$PLACE.1.15.0 ;;
    $PLACE.1.15.*|       \
    $PLACE.1.16)         RET=$PLACE.1.16.0 ;;
    $PLACE.1.16.*|       \
    $PLACE.1.17)         RET=$PLACE.1.17.0 ;;
    $PLACE.1.17.*|       \
    $PLACE.1.*|         \
    $PLACE.2)           RET=$PLACE.2.0.1.0;;
    $PLACE.2.0|		\
    $PLACE.2.0.0|       \
    $PLACE.2.0.0.*|     \
    $PLACE.2.0.1)       RET=$PLACE.2.0.1.0;; 
    $PLACE.2.0.1.*|	\
    $PLACE.2.0.2)       RET=$PLACE.2.0.2.0;; 
    $PLACE.2.0.2.*|	\
    $PLACE.2.0.3)       RET=$PLACE.2.0.3.0;; 
    $PLACE.2.0.3.*|	\
    $PLACE.2.0.4)       RET=$PLACE.2.0.4.0;; 
    $PLACE.2.0.4.*|	\
    $PLACE.2.0.5)       RET=$PLACE.2.0.5.0;; 
    $PLACE.2.0.5.*|	\
    $PLACE.2.0.6)       RET=$PLACE.2.0.6.0;;
    $PLACE.2.0.6.*|     \
    $PLACE.2.1|		\
    $PLACE.2.1.0|       \
    $PLACE.2.1.0.*|     \
    $PLACE.2.1.1)       RET=$PLACE.2.1.1.0;;
    $PLACE.2.1.1.*|     \
    $PLACE.2.1.2)       RET=$PLACE.2.1.2.0;;
    $PLACE.2.1.2.*|     \
    $PLACE.2.1.3)       RET=$PLACE.2.1.3.0;;
    $PLACE.2.1.3.*|     \
    $PLACE.2.1.4)       RET=$PLACE.2.1.4.0;;
    $PLACE.2.1.4.*|     \
    $PLACE.2.1.5)       RET=$PLACE.2.1.5.0;;
    $PLACE.2.1.5.*|     \
    $PLACE.2.1.6)       RET=$PLACE.2.1.6.0;;
    $PLACE.2.1.6.*|     \
    $PLACE.2.1.7)       RET=$PLACE.2.1.7.0;;
    $PLACE.2.1.7.*|     \
    $PLACE.2.1.8)       RET=$PLACE.2.1.8.0;;
    $PLACE.2.1.8.*|     \
    $PLACE.2.1.9)       RET=$PLACE.2.1.9.0;;
    $PLACE.2.1.9.*|     \
    $PLACE.2.1.10)       RET=$PLACE.2.1.10.0;;
    $PLACE.2.1.10.*|     \
    $PLACE.2.1.11)       RET=$PLACE.2.1.11.0;;
    $PLACE.2.1.11.*|     \
    $PLACE.2.1.12)       RET=$PLACE.2.1.12.0;;
    $PLACE.2.1.12.*|     \
    $PLACE.2.1.13)       RET=$PLACE.2.1.13.0;;
    $PLACE.2.1.13.*|     \
    $PLACE.2.1.14)       RET=$PLACE.2.1.14.0;;
    $PLACE.2.1.14.*|     \
    $PLACE.2.1.15)       RET=$PLACE.2.1.15.0;;
    $PLACE.2.1.15.*|     \
    $PLACE.2.1.16)       RET=$PLACE.2.1.16.0;;
    $PLACE.2.1.16.*|     \
    $PLACE.2.1.17)       RET=$PLACE.2.1.17.0;;
    $PLACE.2.1.17.*|     \
    $PLACE.2.1.18)       RET=$PLACE.2.1.18.0;;
    $PLACE.2.1.18.*|     \
    $PLACE.2.1.19)       RET=$PLACE.2.1.19.0;;
    $PLACE.2.1.19.*|     \
    $PLACE.2.1.20)       RET=$PLACE.2.1.20.0;;
    $PLACE.2.1.20.*|     \
    $PLACE.2.2|         \
    $PLACE.2.2.0|       \
    $PLACE.2.2.0.*|     \
    $PLACE.2.2.1)       RET=$PLACE.2.2.1.0;;
    $PLACE.2.2.1.*|     \
    $PLACE.2.2.2)       RET=$PLACE.2.2.2.0;;
    $PLACE.2.2.2.*|     \
    $PLACE.2.2.3)       RET=$PLACE.2.2.3.0;;
    $PLACE.2.2.3.*|     \
    $PLACE.2.2.4)       RET=$PLACE.2.2.4.0;;
    $PLACE.2.2.4.*|     \
    $PLACE.2.2.5)       RET=$PLACE.2.2.5.0;;
    $PLACE.2.2.5.*|     \
    $PLACE.2.2.6)       RET=$PLACE.2.2.6.0;;
    $PLACE.2.2.6.*|     \
    $PLACE.2.2.7)       RET=$PLACE.2.2.7.0;;
    $PLACE.2.2.7.*|     \
    $PLACE.2.2.8)       RET=$PLACE.2.2.8.0;;
    $PLACE.2.2.8.*|     \
    $PLACE.2.2.9)       RET=$PLACE.2.2.9.0;;
    $PLACE.2.2.9.*|     \
    $PLACE.2.2.10)       RET=$PLACE.2.2.10.0;;
    $PLACE.2.2.10.*|     \
    $PLACE.2.2.11)       RET=$PLACE.2.2.11.0;;
    $PLACE.2.2.11.*|     \
    $PLACE.2.2.12)       RET=$PLACE.2.2.12.0;;
    $PLACE.2.2.12.*|     \
    $PLACE.2.2.13)       RET=$PLACE.2.2.13.0;;
    $PLACE.2.2.13.*|     \
    $PLACE.2.2.14)       RET=$PLACE.2.2.14.0;;
    $PLACE.2.2.14.*|     \
    $PLACE.2.2.15)       RET=$PLACE.2.2.15.0;;
    $PLACE.2.2.15.*|     \
    $PLACE.2.2.16)       RET=$PLACE.2.2.16.0;;
    $PLACE.2.2.16.*|     \
    $PLACE.2.2.17)       RET=$PLACE.2.2.17.0;;
    $PLACE.2.2.17.*|     \
    $PLACE.2.2.18)       RET=$PLACE.2.2.18.0;;
    $PLACE.2.2.18.*|     \
    $PLACE.2.2.19)       RET=$PLACE.2.2.19.0;;
    $PLACE.2.2.19.*|     \
    $PLACE.2.2.20)       RET=$PLACE.2.2.20.0;;
    $PLACE.2.2.20.*|     \
    $PLACE.3)           RET=$PLACE.3.1.0;;
    $PLACE.3.0.*|       \
    $PLACE.3.1)         RET=$PLACE.3.1.0 ;; 
    $PLACE.3.1.*|       \
    $PLACE.3.2)         RET=$PLACE.3.2.0 ;; 
    $PLACE.3.2.*|       \
    $PLACE.3.3)         RET=$PLACE.3.3.0 ;;
    $PLACE.3.3.*|       \
    $PLACE.3.4)         RET=$PLACE.3.4.0 ;;
    $PLACE.3.4.*|       \
    $PLACE.3.5)         RET=$PLACE.3.5.0 ;; 
    $PLACE.3.5.*|       \
    $PLACE.3.6)         RET=$PLACE.3.6.0 ;; 
    $PLACE.3.6.*|       \
    $PLACE.3.7)         RET=$PLACE.3.7.0 ;;
    $PLACE.3.7.*|       \
    $PLACE.3.8)         RET=$PLACE.3.8.0 ;;
    $PLACE.3.8.*|       \
    $PLACE.4)           RET=$PLACE.4.1.0;;
    $PLACE.4.0|         \
    $PLACE.4.0.*|       \
    $PLACE.4.1)         RET=$PLACE.4.1.0 ;; 
    $PLACE.4.1.*|       \
    $PLACE.4.2)         RET=$PLACE.4.2.0 ;; 
    $PLACE.4.2.*|       \
    $PLACE.5)           RET=$PLACE.5.1.0;;
    $PLACE.5.0|         \
    $PLACE.5.0.*|       \
    $PLACE.5.1)         RET=$PLACE.5.1.0;; 
    $PLACE.5.1.*|       \
    $PLACE.5.2)         RET=$PLACE.5.2.0 ;; 
    $PLACE.5.2.*|         \
    $PLACE.5.3)         RET=$PLACE.5.3.0;; 
    $PLACE.5.3.*|       \
    $PLACE.5.4)         RET=$PLACE.5.4.0 ;; 
    $PLACE.5.4.*|         \
    $PLACE.5.5)         RET=$PLACE.5.5.0;; 
    $PLACE.5.5.*|       \
    $PLACE.5.6)         RET=$PLACE.5.6.0 ;; 
    $PLACE.5.6.*|         \
    $PLACE.5.7)         RET=$PLACE.5.7.0;; 
    $PLACE.5.7.*|       \
    $PLACE.5.8)         RET=$PLACE.5.8.0 ;; 
    $PLACE.5.8.*|         \
    $PLACE.6)           RET=$PLACE.7.0.1.0;;
    $PLACE.6.0|         \
    $PLACE.6.0.*|       \
    $PLACE.6.*|       	\
    $PLACE.7)           RET=$PLACE.7.0.1.0;;
    $PLACE.7.0|			\
    $PLACE.7.0.0|       \
    $PLACE.7.0.0.*|     \
    $PLACE.7.0.1)       RET=$PLACE.7.0.1.0;; 
    $PLACE.7.0.1.*|		\
    $PLACE.7.0.2)       RET=$PLACE.7.0.2.0;; 
    $PLACE.7.0.2.*|		\
    $PLACE.7.0.3)       RET=$PLACE.7.0.3.0;; 
    $PLACE.7.0.3.*|		\
    $PLACE.7.0.4)       RET=$PLACE.7.0.4.0;; 
    $PLACE.7.0.4.*|		\
    $PLACE.7.0.5)       RET=$PLACE.7.0.5.0;; 
    $PLACE.7.0.5.*|		\
    $PLACE.7.0.6)       RET=$PLACE.7.0.6.0;;
    $PLACE.7.0.6.*|     \
    $PLACE.7.1|			\
    $PLACE.7.1.0|       \
    $PLACE.7.1.0.*|     \
    $PLACE.7.1.1)       RET=$PLACE.7.1.1.0;;
    $PLACE.7.1.1.*|     \
    $PLACE.7.1.2)       RET=$PLACE.7.1.2.0;;
    $PLACE.7.1.2.*|     \
    $PLACE.7.1.3)       RET=$PLACE.7.1.3.0;;
    $PLACE.7.1.3.*|     \
    $PLACE.7.1.4)       RET=$PLACE.7.1.4.0;;
    $PLACE.7.1.4.*|     \
    $PLACE.7.1.5)       RET=$PLACE.7.1.5.0;;
    $PLACE.7.1.5.*|     \
    $PLACE.7.1.6)       RET=$PLACE.7.1.6.0;;
    $PLACE.7.1.6.*|     \
    $PLACE.7.1.7)       RET=$PLACE.7.1.7.0;;
    $PLACE.7.1.7.*|     \
    $PLACE.7.1.8)       RET=$PLACE.7.1.8.0;;
    $PLACE.7.1.8.*|     \
    $PLACE.7.1.9)       RET=$PLACE.7.1.9.0;;
    $PLACE.7.1.9.*|     \
    $PLACE.7.1.10)       RET=$PLACE.7.1.10.0;;
    $PLACE.7.1.10.*|     \
    $PLACE.7.1.11)       RET=$PLACE.7.1.11.0;;
    $PLACE.7.1.11.*|     \
    $PLACE.7.1.12)       RET=$PLACE.7.1.12.0;;
    $PLACE.7.1.12.*|     \
    $PLACE.7.1.13)       RET=$PLACE.7.1.13.0;;
    $PLACE.7.1.13.*|     \
    $PLACE.7.1.14)       RET=$PLACE.7.1.14.0;;
    $PLACE.7.1.14.*|     \
    $PLACE.7.1.15)       RET=$PLACE.7.1.15.0;;
    $PLACE.7.1.15.*|     \
    $PLACE.7.1.16)       RET=$PLACE.7.1.16.0;;
    $PLACE.7.1.16.*|     \
    $PLACE.7.1.17)       RET=$PLACE.7.1.17.0;;
    $PLACE.7.1.17.*|     \
    $PLACE.7.1.18)       RET=$PLACE.7.1.18.0;;
    $PLACE.7.1.18.*|     \
    $PLACE.7.1.19)       RET=$PLACE.7.1.19.0;;
    $PLACE.7.1.19.*|     \
    $PLACE.7.1.20)       RET=$PLACE.7.1.20.0;;
    $PLACE.7.1.20.*|     \
    $PLACE.7.2|         \
    $PLACE.7.2.0|       \
    $PLACE.7.2.0.*|     \
    $PLACE.7.2.1)       RET=$PLACE.7.2.1.0;;
    $PLACE.7.2.1.*|     \
    $PLACE.7.2.2)       RET=$PLACE.7.2.2.0;;
    $PLACE.7.2.2.*|     \
    $PLACE.7.2.3)       RET=$PLACE.7.2.3.0;;
    $PLACE.7.2.3.*|     \
    $PLACE.7.2.4)       RET=$PLACE.7.2.4.0;;
    $PLACE.7.2.4.*|     \
    $PLACE.7.2.5)       RET=$PLACE.7.2.5.0;;
    $PLACE.7.2.5.*|     \
    $PLACE.7.2.6)       RET=$PLACE.7.2.6.0;;
    $PLACE.7.2.6.*|     \
    $PLACE.7.2.7)       RET=$PLACE.7.2.7.0;;
    $PLACE.7.2.7.*|     \
    $PLACE.7.2.8)       RET=$PLACE.7.2.8.0;;
    $PLACE.7.2.8.*|     \
    $PLACE.7.2.9)       RET=$PLACE.7.2.9.0;;
    $PLACE.7.2.9.*|     \
    $PLACE.7.2.10)       RET=$PLACE.7.2.10.0;;
    $PLACE.7.2.10.*|     \
    $PLACE.7.2.11)       RET=$PLACE.7.2.11.0;;
    $PLACE.7.2.11.*|     \
    $PLACE.7.2.12)       RET=$PLACE.7.2.12.0;;
    $PLACE.7.2.12.*|     \
    $PLACE.7.2.13)       RET=$PLACE.7.2.13.0;;
    $PLACE.7.2.13.*|     \
    $PLACE.7.2.14)       RET=$PLACE.7.2.14.0;;
    $PLACE.7.2.14.*|     \
    $PLACE.7.2.15)       RET=$PLACE.7.2.15.0;;
    $PLACE.7.2.15.*|     \
    $PLACE.7.2.16)       RET=$PLACE.7.2.16.0;;
    $PLACE.7.2.16.*|     \
    $PLACE.7.2.17)       RET=$PLACE.7.2.17.0;;
    $PLACE.7.2.17.*|     \
    $PLACE.7.2.18)       RET=$PLACE.7.2.18.0;;
    $PLACE.7.2.18.*|     \
    $PLACE.7.2.19)       RET=$PLACE.7.2.19.0;;
    $PLACE.7.2.19.*|     \
    $PLACE.7.2.20)       RET=$PLACE.7.2.20.0;;
    $PLACE.7.2.20.*|     \
    $PLACE.7.2.*|       \
    $PLACE.7.*|         \
    $PLACE.8)           RET=$PLACE.8.0.1.0;;
    $PLACE.8.0|			\
    $PLACE.8.0.0|       \
    $PLACE.8.0.0.*|     \
    $PLACE.8.0.1)       RET=$PLACE.8.0.1.0;; 
    $PLACE.8.0.1.*|		\
    $PLACE.8.1|			\
    $PLACE.8.1.0|       \
    $PLACE.8.1.0.*|     \
    $PLACE.8.1.1)       RET=$PLACE.8.1.1.0;;
    $PLACE.8.1.1.*|     \
    $PLACE.8.1.2)       RET=$PLACE.8.1.2.0;;
    $PLACE.8.1.2.*|     \
    $PLACE.8.1.3)       RET=$PLACE.8.1.3.0;;
    $PLACE.8.1.3.*|     \
    $PLACE.8.1.4)       RET=$PLACE.8.1.4.0;;
    $PLACE.8.1.4.*|     \
    $PLACE.8.1.5)       RET=$PLACE.8.1.5.0;;
    $PLACE.8.1.5.*|     \
    $PLACE.8.2|			\
    $PLACE.8.2.0|       \
    $PLACE.8.2.0.*|     \
    $PLACE.8.2.1)       RET=$PLACE.8.2.1.0;;
    $PLACE.8.2.1.*|     \
    $PLACE.8.2.2)       RET=$PLACE.8.2.2.0;;
    $PLACE.8.2.2.*|     \
    $PLACE.8.2.3)       RET=$PLACE.8.2.3.0;;
    $PLACE.8.2.3.*|     \
    $PLACE.8.2.4)       RET=$PLACE.8.2.4.0;;
    $PLACE.8.2.4.*|     \
    $PLACE.8.2.5)       RET=$PLACE.8.2.5.0;;
    $PLACE.8.2.5.*|     \
    $PLACE.8.3|			\
    $PLACE.8.3.0|       \
    $PLACE.8.3.0.*|     \
    $PLACE.8.3.1)       RET=$PLACE.8.3.1.0;;
    $PLACE.8.3.1.*|     \
    $PLACE.8.3.2)       RET=$PLACE.8.3.2.0;;
    $PLACE.8.3.2.*|     \
    $PLACE.8.3.3)       RET=$PLACE.8.3.3.0;;
    $PLACE.8.3.3.*|     \
    $PLACE.8.3.4)       RET=$PLACE.8.3.4.0;;
    $PLACE.8.3.4.*|     \
    $PLACE.8.3.5)       RET=$PLACE.8.3.5.0;;
    $PLACE.8.3.5.*|     \
    $PLACE.8.4|			\
    $PLACE.8.4.0|       \
    $PLACE.8.4.0.*|     \
    $PLACE.8.4.1)       RET=$PLACE.8.4.1.0;;
    $PLACE.8.4.1.*|     \
    $PLACE.8.4.2)       RET=$PLACE.8.4.2.0;;
    $PLACE.8.4.2.*|     \
    $PLACE.8.4.3)       RET=$PLACE.8.4.3.0;;
    $PLACE.8.4.3.*|     \
    $PLACE.8.4.4)       RET=$PLACE.8.4.4.0;;
    $PLACE.8.4.4.*|     \
    $PLACE.8.4.5)       RET=$PLACE.8.4.5.0;;
    $PLACE.8.4.5.*|     \
    $PLACE.8.5|			\
    $PLACE.8.5.0|       \
    $PLACE.8.5.0.*|     \
    $PLACE.8.5.1)       RET=$PLACE.8.5.1.0;;
    $PLACE.8.5.1.*|     \
    $PLACE.8.5.2)       RET=$PLACE.8.5.2.0;;
    $PLACE.8.5.2.*|     \
    $PLACE.8.5.3)       RET=$PLACE.8.5.3.0;;
    $PLACE.8.5.3.*|     \
    $PLACE.8.5.4)       RET=$PLACE.8.5.4.0;;
    $PLACE.8.5.4.*|     \
    $PLACE.8.5.5)       RET=$PLACE.8.5.5.0;;
    $PLACE.8.5.5.*|     \
    $PLACE.8.5.*|     	\
    $PLACE.9)           RET=$PLACE.9.1.1.0;;
    $PLACE.9.0|			\
    $PLACE.9.0.0.*|     \
    $PLACE.9.0.1)       RET=$PLACE.9.0.1.0;; 	
    $PLACE.9.1|			\
    $PLACE.9.1.0|       \
    $PLACE.9.1.0.*|     \
    $PLACE.9.1.1)       RET=$PLACE.9.1.1.0;;
    $PLACE.9.1.1.*|     \
    $PLACE.9.1.2)       RET=$PLACE.9.1.2.0;;
    $PLACE.9.1.2.*|     \
    $PLACE.9.1.3)       RET=$PLACE.9.1.3.0;;
    $PLACE.9.1.3.*|     \
    $PLACE.9.1.4)       RET=$PLACE.9.1.4.0;;
    $PLACE.9.1.4.*|     \
    $PLACE.9.1.5)       RET=$PLACE.9.1.5.0;;
    $PLACE.9.1.5.*|     \
    $PLACE.9.1.6)       RET=$PLACE.9.1.6.0;;
    $PLACE.9.1.6.*|     \
    $PLACE.9.1.7)       RET=$PLACE.9.1.7.0;;
    $PLACE.9.1.7.*|     \
    $PLACE.9.1.8)       RET=$PLACE.9.1.8.0;;
    $PLACE.9.1.8.*|     \
    $PLACE.9.1.9)       RET=$PLACE.9.1.9.0;;
    $PLACE.9.1.9.*|     \
    $PLACE.9.2|			\
    $PLACE.9.2.0|       \
    $PLACE.9.2.0.*|     \
    $PLACE.9.2.1)       RET=$PLACE.9.2.1.0;;
    $PLACE.9.2.1.*|     \
    $PLACE.9.2.2)       RET=$PLACE.9.2.2.0;;
    $PLACE.9.2.2.*|     \
    $PLACE.9.2.3)       RET=$PLACE.9.2.3.0;;
    $PLACE.9.2.3.*|     \
    $PLACE.9.2.4)       RET=$PLACE.9.2.4.0;;
    $PLACE.9.2.4.*|     \
    $PLACE.9.2.5)       RET=$PLACE.9.2.5.0;;
    $PLACE.9.2.5.*|     \
    $PLACE.9.2.6)       RET=$PLACE.9.2.6.0;;
    $PLACE.9.2.6.*|     \
    $PLACE.9.2.7)       RET=$PLACE.9.2.7.0;;
    $PLACE.9.2.7.*|     \
    $PLACE.9.2.8)       RET=$PLACE.9.2.8.0;;
    $PLACE.9.2.8.*|     \
    $PLACE.9.2.9)       RET=$PLACE.9.2.9.0;;
    $PLACE.9.2.9.*|     \
    *)                  exit 0 ;;
  esac
else
#
#  GET requests - check for valid instance
#
  case "$REQ" in
    $PLACE|             	\
    $PLACE.1.1.0|         \
    $PLACE.1.2.0|         \
    $PLACE.1.3.0|         \
    $PLACE.1.4.0|         \
    $PLACE.1.5.0|         \
    $PLACE.1.6.0|         \
    $PLACE.1.7.0|         \
    $PLACE.1.8.0|         \
    $PLACE.1.9.0|         \
    $PLACE.1.10.0|         \
    $PLACE.1.11.0|         \
    $PLACE.1.12.0|         \
    $PLACE.1.13.0|         \
    $PLACE.1.14.0|         \
    $PLACE.1.15.0|         \
    $PLACE.1.16.0|         \
    $PLACE.1.17.0|         \
    $PLACE.2.0.1.0|         \
    $PLACE.2.0.2.0|         \
    $PLACE.2.0.3.0|         \
    $PLACE.2.0.4.0|         \
    $PLACE.2.0.5.0|         \
    $PLACE.2.0.6.0|         \
    $PLACE.2.1.1.0|         \
    $PLACE.2.1.2.0|         \
    $PLACE.2.1.3.0|         \
    $PLACE.2.1.4.0|         \
    $PLACE.2.1.5.0|         \
    $PLACE.2.1.6.0|         \
    $PLACE.2.1.7.0|         \
    $PLACE.2.1.8.0|         \
    $PLACE.2.1.9.0|         \
    $PLACE.2.1.10.0|         \
    $PLACE.2.1.11.0|         \
    $PLACE.2.1.12.0|         \
    $PLACE.2.1.13.0|         \
    $PLACE.2.1.14.0|         \
    $PLACE.2.1.15.0|         \
    $PLACE.2.1.16.0|         \
    $PLACE.2.1.17.0|         \
    $PLACE.2.1.18.0|         \
    $PLACE.2.1.19.0|         \
    $PLACE.2.1.20.0|         \
    $PLACE.2.2.1.0|         \
    $PLACE.2.2.2.0|         \
    $PLACE.2.2.3.0|         \
    $PLACE.2.2.4.0|         \
    $PLACE.2.2.5.0|         \
    $PLACE.2.2.6.0|         \
    $PLACE.2.2.7.0|         \
    $PLACE.2.2.8.0|         \
    $PLACE.2.2.9.0|         \
    $PLACE.2.2.10.0|         \
    $PLACE.2.2.11.0|         \
    $PLACE.2.2.12.0|         \
    $PLACE.2.2.13.0|         \
    $PLACE.2.2.14.0|         \
    $PLACE.2.2.15.0|         \
    $PLACE.2.2.16.0|         \
    $PLACE.2.2.17.0|         \
    $PLACE.2.2.18.0|         \
    $PLACE.2.2.19.0|         \
    $PLACE.2.2.20.0|         \
    $PLACE.3.1.0|         \
    $PLACE.3.2.0|         \
    $PLACE.3.3.0|         \
    $PLACE.3.4.0|         \
    $PLACE.3.5.0|         \
    $PLACE.3.6.0|         \
    $PLACE.3.7.0|         \
    $PLACE.3.8.0|         \
    $PLACE.4.1.0|         \
    $PLACE.4.2.0|         \
    $PLACE.5.1.0|         \
    $PLACE.5.2.0|         \
    $PLACE.5.3.0|         \
    $PLACE.5.4.0|         \
    $PLACE.5.5.0|         \
    $PLACE.5.6.0|         \
    $PLACE.5.7.0|         \
    $PLACE.5.8.0|         \
    $PLACE.7.0.1.0|         \
    $PLACE.7.0.2.0|         \
    $PLACE.7.0.3.0|         \
    $PLACE.7.0.4.0|         \
    $PLACE.7.0.5.0|         \
    $PLACE.7.0.6.0|         \
    $PLACE.7.1.1.0|         \
    $PLACE.7.1.2.0|         \
    $PLACE.7.1.3.0|         \
    $PLACE.7.1.4.0|         \
    $PLACE.7.1.5.0|         \
    $PLACE.7.1.6.0|         \
    $PLACE.7.1.7.0|         \
    $PLACE.7.1.8.0|         \
    $PLACE.7.1.9.0|         \
    $PLACE.7.1.10.0|         \
    $PLACE.7.1.11.0|         \
    $PLACE.7.1.12.0|         \
    $PLACE.7.1.13.0|         \
    $PLACE.7.1.14.0|         \
    $PLACE.7.1.15.0|         \
    $PLACE.7.1.16.0|         \
    $PLACE.7.1.17.0|         \
    $PLACE.7.1.18.0|         \
    $PLACE.7.1.19.0|         \
    $PLACE.7.1.20.0|         \
    $PLACE.7.2.1.0|         \
    $PLACE.7.2.2.0|         \
    $PLACE.7.2.3.0|         \
    $PLACE.7.2.4.0|         \
    $PLACE.7.2.5.0|         \
    $PLACE.7.2.6.0|         \
    $PLACE.7.2.7.0|         \
    $PLACE.7.2.8.0|         \
    $PLACE.7.2.9.0|         \
    $PLACE.7.2.10.0|         \
    $PLACE.7.2.11.0|         \
    $PLACE.7.2.12.0|         \
    $PLACE.7.2.13.0|         \
    $PLACE.7.2.14.0|         \
    $PLACE.7.2.15.0|         \
    $PLACE.7.2.16.0|         \
    $PLACE.7.2.17.0|         \
    $PLACE.7.2.18.0|         \
    $PLACE.7.2.19.0|         \
    $PLACE.7.2.20.0|         \
    $PLACE.8.0.1.0|         \
    $PLACE.8.1.1.0|         \
    $PLACE.8.1.2.0|         \
    $PLACE.8.1.3.0|         \
    $PLACE.8.1.4.0|         \
    $PLACE.8.1.5.0|         \
    $PLACE.8.2.1.0|         \
    $PLACE.8.2.2.0|         \
    $PLACE.8.2.3.0|         \
    $PLACE.8.2.4.0|         \
    $PLACE.8.2.5.0|         \
    $PLACE.8.3.1.0|         \
    $PLACE.8.3.2.0|         \
    $PLACE.8.3.3.0|         \
    $PLACE.8.3.4.0|         \
    $PLACE.8.3.5.0|         \
    $PLACE.8.4.1.0|         \
    $PLACE.8.4.2.0|         \
    $PLACE.8.4.3.0|         \
    $PLACE.8.4.4.0|         \
    $PLACE.8.4.5.0|         \
    $PLACE.8.5.1.0|         \
    $PLACE.8.5.2.0|         \
    $PLACE.8.5.3.0|         \
    $PLACE.8.5.4.0|         \
    $PLACE.8.5.5.0|         \
    $PLACE.9.1.1.0|         \
    $PLACE.9.1.2.0|         \
    $PLACE.9.1.3.0|         \
    $PLACE.9.1.4.0|         \
    $PLACE.9.1.5.0|         \
    $PLACE.9.1.6.0|         \
    $PLACE.9.1.7.0|         \
    $PLACE.9.1.8.0|         \
    $PLACE.9.1.9.0|         \
    $PLACE.9.2.1.0|         \
    $PLACE.9.2.2.0|         \
    $PLACE.9.2.3.0|         \
    $PLACE.9.2.4.0|         \
    $PLACE.9.2.5.0|         \
    $PLACE.9.2.6.0|         \
    $PLACE.9.2.7.0|         \
    $PLACE.9.2.8.0|         \
    $PLACE.9.2.9.0|         \
    $PLACE.5.0)     RET=$REQ ;;
    *)              exit 0 ;;
  esac
fi
#
#  "Process" GET* requests - return hard-coded value
#
echo "$RET"
case "$RET" in
  $PLACE.1.1.0) 	echo "string";	value=$(ash /etc/snmp/system_info.sh deviceModel); 	echo "$value";          exit 0 ;;
  $PLACE.1.2.0)		echo "string"; 	value=$(ash /etc/snmp/system_info.sh deviceSerialNum); 	echo "$value";          exit 0 ;;
  $PLACE.1.3.0)		echo "string"; 	value=$(ash /etc/snmp/system_info.sh deviceHWVer); 	echo "$value";          exit 0 ;;
  $PLACE.1.4.0)	    echo "string";	value=$(ash /etc/snmp/system_info.sh deviceBatchNumber); echo "$value";          exit 0 ;;
  $PLACE.1.5.0)		echo "string";	value=$(ash /etc/snmp/system_info.sh deviceRouterFirmware); echo "$value";          exit 0 ;;
  $PLACE.1.6.0)		echo "string";	value=$(ash /etc/snmp/system_info.sh deviceGatewayFirmware); echo "$value";          exit 0 ;;
  $PLACE.1.7.0)		echo "string";	value=$(ash /etc/snmp/system_info.sh deviceUptime); echo "$value";    exit 0 ;;
  $PLACE.1.8.0)		echo "string";	value=$(ash /etc/snmp/system_info.sh deviceTemperature); echo "$value";          exit 0 ;;
  $PLACE.1.9.0)		echo "string";	value=$(ash /etc/snmp/system_info.sh deviceNoofModem); echo "$value";          exit 0 ;;
  $PLACE.1.10.0)	echo "string";	value=$(ash /etc/snmp/system_info.sh deviceInternetStatus); echo "$value";          exit 0 ;;
  $PLACE.1.11.0) 	echo "string";	value=$(ash /etc/snmp/system_info.sh deviceActiveInetInterfaceName); 	echo "$value";          exit 0 ;;
  $PLACE.1.12.0)	echo "string"; 	value=$(ash /etc/snmp/system_info.sh deviceEWANInternetStatus); 	echo "$value";          exit 0 ;;
  $PLACE.1.13.0)	echo "string";	value=$(ash /etc/snmp/snmp_boardinfo.sh numberOfDIOpin); 	echo "$value";          exit 0 ;;
  $PLACE.1.14.0)	echo "string";	value=$(ash /etc/snmp/snmp_boardinfo.sh numberOfAIpin); echo "$value";          exit 0 ;;
  $PLACE.1.15.0)	echo "string";	value=$(ash /etc/snmp/snmp_boardinfo.sh numberOftempSensor); echo "$value";          exit 0 ;;
  $PLACE.1.16.0)	echo "string";	value=$(ash /etc/snmp/snmp_boardinfo.sh numberOfDIOTraps); echo "$value";          exit 0 ;;
  $PLACE.1.17.0)	echo "string";	value=$(ash /etc/snmp/system_info.sh deviceCellularOperationMode); echo "$value";          exit 0 ;;
  $PLACE.2.0.1.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1Revision); echo "$value";          exit 0 ;;
  $PLACE.2.0.2.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1Manufacturer); echo "$value";          exit 0 ;;
  $PLACE.2.0.3.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1IMSI); echo "$value";          exit 0 ;;
  $PLACE.2.0.4.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1Model); echo "$value";          exit 0 ;;
  $PLACE.2.0.5.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1IMEI); echo "$value";          exit 0 ;;
  $PLACE.2.0.6.0)		echo "string";	value=$(ash /etc/snmp/modem1_info.sh modem1ActiveSim); echo "$value";          exit 0 ;;
  $PLACE.2.1.1.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1RegState);	echo "$value";          exit 0 ;;
  $PLACE.2.1.2.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1PinState); echo "$value"; exit 0 ;;
  $PLACE.2.1.3.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1SignalStrengthCSQ); echo "$value"; exit 0 ;;
  $PLACE.2.1.4.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1Operator); echo "$value";          exit 0 ;;
  $PLACE.2.1.5.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1OperatorCode); echo "$value";          exit 0 ;;
  $PLACE.2.1.6.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1CellID); 	echo "$value";          exit 0 ;;
  $PLACE.2.1.7.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1SentToday); echo "$value"; exit 0 ;;
  $PLACE.2.1.8.0)      echo "string"; 	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1ReceivedToday); echo "$value"; exit 0 ;;
  $PLACE.2.1.9.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1SentTillDateThisMonth); echo "$value"; exit 0 ;;
  $PLACE.2.1.10.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1ReceivedTDateTMonth); echo "$value";   exit 0 ;;
  $PLACE.2.1.11.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1ConnectionState); echo "$value"; exit 0 ;;
  $PLACE.2.1.12.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1ConnectionMode); echo "$value"; exit 0 ;;
  $PLACE.2.1.13.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1SINR); echo "$value";          exit 0 ;;
  $PLACE.2.1.14.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1RSRP); echo "$value";          exit 0 ;;
  $PLACE.2.1.15.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1RSRQ); echo "$value";          exit 0 ;;
  $PLACE.2.1.16.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1RSSI); echo "$value";          exit 0 ;;
  $PLACE.2.1.17.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1IP); echo "$value";          exit 0 ;;
  $PLACE.2.1.18.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1QCCID); echo "$value";          exit 0 ;;
  $PLACE.2.1.19.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1FDDIMode); echo "$value";          exit 0 ;;
  $PLACE.2.1.20.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim1_info.sh modem1sim1BandNumber); echo "$value";          exit 0 ;;
  $PLACE.2.2.1.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2RegState);	echo "$value";          exit 0 ;;
  $PLACE.2.2.2.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2PinState); echo "$value";          exit 0 ;;
  $PLACE.2.2.3.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2SignalStrengthCSQ); echo "$value";          exit 0 ;;
  $PLACE.2.2.4.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2Operator); echo "$value";          exit 0 ;;
  $PLACE.2.2.5.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2OperatorCode); echo "$value";          exit 0 ;;
  $PLACE.2.2.6.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2CellID); echo "$value";          exit 0 ;;
  $PLACE.2.2.7.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2SentToday); echo "$value";          exit 0 ;;
  $PLACE.2.2.8.0)      echo "string"; 	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2ReceivedToday); echo "$value";  exit 0 ;;
  $PLACE.2.2.9.0)      echo "string";	 value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2SentTillDateThisMonth); echo "$value";  exit 0 ;;
  $PLACE.2.2.10.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2ReceivedTDateTMonth); echo "$value"; exit 0 ;;
  $PLACE.2.2.11.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2ConnectionState); echo "$value"; exit 0 ;;
  $PLACE.2.2.12.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2ConnectionMode); echo "$value"; exit 0 ;;
  $PLACE.2.2.13.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2SINR); echo "$value";          exit 0 ;;
  $PLACE.2.2.14.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2RSRP); echo "$value";          exit 0 ;;
  $PLACE.2.2.15.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2RSRQ); echo "$value";          exit 0 ;;
  $PLACE.2.2.16.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2RSSI); echo "$value";          exit 0 ;;
  $PLACE.2.2.17.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2IP); echo "$value";          exit 0 ;;
  $PLACE.2.2.18.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2QCCID); echo "$value";          exit 0 ;;
  $PLACE.2.2.19.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2FDDIMode); echo "$value";          exit 0 ;;
  $PLACE.2.2.20.0)     echo "string";    value=$(ash /etc/snmp/modem1_sim2_info.sh modem1sim2BandNumber); echo "$value";          exit 0 ;;
  $PLACE.3.1.0)        echo "string";    data=$(ash /etc/snmp/dioinfo.sh dioPin1ConfigStatus);   echo "$data";                   exit 0 ;;
  $PLACE.3.2.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin2ConfigStatus);   echo "$data";                   exit 0 ;;
  $PLACE.3.3.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin3ConfigStatus);    echo "$data";                   exit 0 ;;
  $PLACE.3.4.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin4ConfigStatus);    echo "$data";                   exit 0 ;;
  $PLACE.3.5.0)        echo "string";    data=$(ash /etc/snmp/dioinfo.sh dioPin1CurrentStatus);   echo "$data";                   exit 0 ;;
  $PLACE.3.6.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin2CurrentStatus);   echo "$data";                   exit 0 ;;
  $PLACE.3.7.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin3CurrentStatus);    echo "$data";                   exit 0 ;;
  $PLACE.3.8.0)        echo "string";   data=$(ash /etc/snmp/dioinfo.sh dioPin4CurrentStatus);    echo "$data";                   exit 0 ;;
  $PLACE.4.1.0) 	echo "string"; data=$(ash /etc/snmp/aiinfo.sh aiPin1); echo "$data"; exit 0 ;;
  $PLACE.4.2.0) 	echo "string"; data=$(ash /etc/snmp/aiinfo.sh aiPin2); echo "$data"; exit 0 ;;
  $PLACE.5.1.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature1); echo "$data"; exit 0 ;;
  $PLACE.5.2.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature2); echo "$data"; exit 0 ;;
  $PLACE.5.3.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature3); echo "$data"; exit 0 ;;
  $PLACE.5.4.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature4); echo "$data"; exit 0 ;;
  $PLACE.5.5.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature5); echo "$data"; exit 0 ;;
  $PLACE.5.6.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature6); echo "$data"; exit 0 ;;
  $PLACE.5.7.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature7); echo "$data"; exit 0 ;;
  $PLACE.5.8.0) 	echo "string"; data=$(ash /etc/snmp/temperatureinfo.sh temperature8); echo "$data"; exit 0 ;;
  $PLACE.7.0.1.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2Revision); echo "$value";          exit 0 ;;
  $PLACE.7.0.2.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2Manufacturer); echo "$value";          exit 0 ;;
  $PLACE.7.0.3.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2IMSI); echo "$value";          exit 0 ;;
  $PLACE.7.0.4.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2Model); echo "$value";          exit 0 ;;
  $PLACE.7.0.5.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2IMEI); echo "$value";          exit 0 ;;
  $PLACE.7.0.6.0)		echo "string";	value=$(ash /etc/snmp/modem2_info.sh modem2ActiveSim); echo "$value";          exit 0 ;;
  $PLACE.7.1.1.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1RegState);					echo "$value";          exit 0 ;;
  $PLACE.7.1.2.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1PinState); 				echo "$value";          exit 0 ;;
  $PLACE.7.1.3.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1SignalStrengthCSQ); 		echo "$value";          exit 0 ;;
  $PLACE.7.1.4.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1Operator); 				echo "$value";          exit 0 ;;
  $PLACE.7.1.5.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1OperatorCode); 		echo "$value";          exit 0 ;;
  $PLACE.7.1.6.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1CellID); 				echo "$value";          exit 0 ;;
  $PLACE.7.1.7.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1SentToday);				echo "$value";          exit 0 ;;
  $PLACE.7.1.8.0)      echo "string"; 	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1ReceivedToday); 		echo "$value";          exit 0 ;;
  $PLACE.7.1.9.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1SentTillDateThisMonth); 					echo "$value";          exit 0 ;;
  $PLACE.7.1.10.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1ReceivedTDateTMonth); 				echo "$value";          exit 0 ;;
  $PLACE.7.1.11.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1ConnectionState);		echo "$value";          exit 0 ;;
  $PLACE.7.1.12.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1ConnectionMode); 		echo "$value";          exit 0 ;;
  $PLACE.7.1.13.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1SINR); 			echo "$value";          exit 0 ;;
  $PLACE.7.1.14.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1RSRP); 					echo "$value";          exit 0 ;;
  $PLACE.7.1.15.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1RSRQ);				 	echo "$value";          exit 0 ;;
  $PLACE.7.1.16.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1RSSI);					echo "$value";          exit 0 ;;
  $PLACE.7.1.17.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1IP);					echo "$value";          exit 0 ;;
  $PLACE.7.1.18.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1QCCID); 					echo "$value";          exit 0 ;;
  $PLACE.7.1.19.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1FDDIMode); 					echo "$value";          exit 0 ;;
  $PLACE.7.1.20.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim1_info.sh modem2sim1BandNumber); 	echo "$value";          exit 0 ;;
  $PLACE.7.2.1.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2RegState);					echo "$value";          exit 0 ;;
  $PLACE.7.2.2.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2PinState); 				echo "$value";          exit 0 ;;
  $PLACE.7.2.3.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2SignalStrengthCSQ); 		echo "$value";          exit 0 ;;
  $PLACE.7.2.4.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2Operator); 				echo "$value";          exit 0 ;;
  $PLACE.7.2.5.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2OperatorCode); 		echo "$value";          exit 0 ;;
  $PLACE.7.2.6.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2CellID); 				echo "$value";          exit 0 ;;
  $PLACE.7.2.7.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2SentToday);				echo "$value";          exit 0 ;;
  $PLACE.7.2.8.0)      echo "string"; 	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2ReceivedToday); 		echo "$value";          exit 0 ;;
  $PLACE.7.2.9.0)      echo "string";	 value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2SentTillDateThisMonth); 					echo "$value";          exit 0 ;;
  $PLACE.7.2.10.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2ReceivedTDateTMonth); 				echo "$value";          exit 0 ;;
  $PLACE.7.2.11.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2ConnectionState);		echo "$value";          exit 0 ;;
  $PLACE.7.2.12.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2ConnectionMode); 		echo "$value";          exit 0 ;;
  $PLACE.7.2.13.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2SINR); 			echo "$value";          exit 0 ;;
  $PLACE.7.2.14.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2RSRP); 					echo "$value";          exit 0 ;;
  $PLACE.7.2.15.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2RSRQ);				 	echo "$value";          exit 0 ;;
  $PLACE.7.2.16.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2RSSI);					echo "$value";          exit 0 ;;
  $PLACE.7.2.17.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2IP);					echo "$value";          exit 0 ;;
  $PLACE.7.2.18.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2QCCID); 					echo "$value";          exit 0 ;;
  $PLACE.7.2.19.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2FDDIMode); 					echo "$value";          exit 0 ;;
  $PLACE.7.2.20.0)     echo "string";    value=$(ash /etc/snmp/modem2_sim2_info.sh modem2sim2BandNumber); 	echo "$value";          exit 0 ;;
  $PLACE.8.0.1.0)      echo "string";	value=$(ash /etc/snmp/portinfo.sh port_number_count);           echo "$value";          exit 0 ;;
  $PLACE.8.1.1.0)      echo "string";	 value=$(ash /etc/snmp/portinfo.sh  port0_name);	echo "$value";          exit 0 ;;
  $PLACE.8.1.2.0)      echo "string";	 value=$(ash /etc/snmp/portinfo.sh  port1_name); echo "$value";          exit 0 ;;
  $PLACE.8.1.3.0)      echo "string";	 value=$(ash /etc/snmp/portinfo.sh  port2_name); echo "$value"; exit 0 ;;
  $PLACE.8.1.4.0)      echo "string";	 value=$(ash /etc/snmp/portinfo.sh  port3_name);	echo "$value";          exit 0 ;;
  $PLACE.8.1.5.0)      echo "string";	 value=$(ash /etc/snmp/portinfo.sh  port4_name); echo "$value";      exit 0 ;;
  $PLACE.8.2.1.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port0_number); echo "$value";          exit 0 ;;    
  $PLACE.8.2.2.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port1_number); echo "$value";          exit 0 ;;    
  $PLACE.8.2.3.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port2_number); echo "$value"; exit 0 ;;     
  $PLACE.8.2.4.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port3_number); echo "$value";          exit 0 ;;       
  $PLACE.8.2.5.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port4_number); echo "$value";      exit 0 ;;       
  $PLACE.8.3.1.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port0_link_status); echo "$value";          exit 0 ;;    
  $PLACE.8.3.2.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port1_link_status); echo "$value";          exit 0 ;;     
  $PLACE.8.3.3.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port2_link_status); echo "$value"; exit 0 ;;    
  $PLACE.8.3.4.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port3_link_status); echo "$value";          exit 0 ;;  
  $PLACE.8.3.5.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port4_link_status); echo "$value";      exit 0 ;;    
  $PLACE.8.4.1.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port0_speed); echo "$value";          exit 0 ;;     
  $PLACE.8.4.2.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port1_speed); echo "$value";          exit 0 ;;      
  $PLACE.8.4.3.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port2_speed); echo "$value"; exit 0 ;;    
  $PLACE.8.4.4.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port3_speed); echo "$value";          exit 0 ;;       
  $PLACE.8.4.5.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port4_speed); echo "$value";      exit 0 ;;       
  $PLACE.8.5.1.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port0_duplex); echo "$value";          exit 0 ;;    
  $PLACE.8.5.2.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port1_duplex); echo "$value";          exit 0 ;;    
  $PLACE.8.5.3.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port2_duplex); echo "$value"; exit 0 ;;     
  $PLACE.8.5.4.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port3_duplex); echo "$value";          exit 0 ;;      
  $PLACE.8.5.5.0)      echo "string";    value=$(ash /etc/snmp/portinfo.sh port4_duplex); echo "$value";      exit 0 ;;      
  $PLACE.9.1.1.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_Mode_2.4GHz); echo "$value";          exit 0 ;;    
  $PLACE.9.1.2.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Channel_Bandwidth_2.4GHz); echo "$value";     exit 0 ;;
  $PLACE.9.1.3.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Country_Code_2.4GHz); echo "$value"; exit 0 ;;      
  $PLACE.9.1.4.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Country_Region_2.4GHz); echo "$value";           exit 0 ;;      
  $PLACE.9.1.5.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Channel_2.4GHz); echo "$value";          exit 0 ;;   
  $PLACE.9.1.6.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh WirelessMode_2.4GHz); echo "$value";          exit 0 ;;    
  $PLACE.9.1.7.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh TXpower_2.4GHz); echo "$value";          exit 0 ;;    
  $PLACE.9.1.8.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_2.4GHz_SSID); echo "$value";      exit 0 ;;  
  $PLACE.9.1.9.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_2.4GHz_guest_wifi_SSID); echo "$value";      exit 0 ;;  
  $PLACE.9.2.1.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_Mode_5.0GHz); echo "$value";          exit 0 ;;      
  $PLACE.9.2.2.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Channel_Bandwidth_5.0GHz); echo "$value"; exit 0 ;;     
  $PLACE.9.2.3.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Country_Code_5.0GHz); echo "$value"; exit 0 ;;       
  $PLACE.9.2.4.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Country_Region_5.0GHz); echo "$value";          exit 0 ;;       
  $PLACE.9.2.5.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Channel_5.0GHz); echo "$value";      exit 0 ;;    
  $PLACE.9.2.6.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh WirelessMode_5.0GHz); echo "$value";          exit 0 ;;     
  $PLACE.9.2.7.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh TXpower_5.0GHz); echo "$value";          exit 0 ;;     
  $PLACE.9.2.8.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_SSID_5.0GHz); echo "$value";      exit 0 ;;  
  $PLACE.9.2.9.0)      echo "string";    value=$(ash /etc/snmp/wifiinfo.sh Radio_guest_wifi_SSID_5.0GHz); echo "$value";      exit 0 ;;  
*) echo "string";    echo "ack... $RET $REQ";                            exit 0 ;; 
esac
