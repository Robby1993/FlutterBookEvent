import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitialState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthOtpVerifyLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthReSendOtpLoadingState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthCodeSentState extends AuthState {
  final String verificationId;

  AuthCodeSentState(this.verificationId);

  @override
  List<Object> get props => [verificationId];
}

class AuthCodeReSentState extends AuthState {
  final String verificationId;

  AuthCodeReSentState(this.verificationId);

  @override
  List<Object> get props => [];
}

class AuthCodeVerifiedState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthLoggedInState extends AuthState {
  final User firebaseUser;

  AuthLoggedInState(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];
}



class AuthEmailLoggedInState extends AuthState {
  final User firebaseUser;

  AuthEmailLoggedInState(this.firebaseUser);

  @override
  List<Object> get props => [firebaseUser];
}

class AuthEmailRegisteredState extends AuthState {
  AuthEmailRegisteredState();
  @override
  List<Object> get props => [];
}



class AuthLoggedApiInState extends AuthState {
  final dynamic data;
  AuthLoggedApiInState(this.data);

  @override
  List<Object> get props => [data];
}

class AuthLoggedOutState extends AuthState {
  @override
  List<Object> get props => [];
}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthTimeOutErrorState extends AuthState {
  final String error;
  AuthTimeOutErrorState(this.error);

  @override
  List<Object> get props => [error];
}


class AuthVerifyErrorState extends AuthState {
  final String error;

  AuthVerifyErrorState(this.error);

  @override
  List<Object> get props => [error];
}

class AuthVerifyCodeState extends AuthState {
  final String otp;

  AuthVerifyCodeState(this.otp);

  @override
  List<Object> get props => [otp];
}
