import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:stegaimg/utilities/configs.dart';

int extractLastBit(int pixel) {
  int lastBit = pixel & 1;
  return lastBit;
}

int assembleBits(Uint16List byte) {
  if (byte.length != dataLength) {
    throw FlutterError('byte_incorrect_size');
  }
  int assembled = 0;
  for (int i = 0; i < dataLength; ++i) {
    if (byte[i] != 1 && byte[i] != 0) {
      throw FlutterError('bit_not_0_or_1');
    }
    assembled = assembled << 1;
    assembled = assembled | byte[i];
  }
  return assembled;
}

Uint16List bits2bytes(Uint16List bits) {
  if ((bits.length % dataLength) != 0) {
    throw FlutterError('bits_contain_incomplete_byte');
  }
  int byteCnt = bits.length ~/ dataLength;
  Uint16List byteMsg = Uint16List(byteCnt);
  for (int i = 0; i < byteCnt; ++i) {
    Uint16List bitsOfByte = Uint16List.fromList(
        bits.getRange(i * dataLength, i * dataLength + dataLength).toList());
    int byte = assembleBits(bitsOfByte);
    byteMsg[i] = byte;
  }
  return byteMsg;
}

Uint16List extractBitsFromImg(Uint16List img) {
  Uint16List extracted = Uint16List(img.length);
  for (int i = 0; i < img.length; i++) {
    extracted[i] = extractLastBit(img[i]);
  }
  return extracted;
}

Uint16List sanitizePaddingZeros(Uint16List msg) {
  int lastNonZeroIdx = msg.length - 1;
  while (msg[lastNonZeroIdx] == 0) {
    --lastNonZeroIdx;
  }
  Uint16List sanitized =
  Uint16List.fromList(msg.getRange(0, lastNonZeroIdx + 1).toList());
  return sanitized;
}

Uint16List padToBytes(Uint16List msg) {
  int padSize = dataLength - msg.length % dataLength;
  Uint16List padded = Uint16List(msg.length + padSize);
  for (int i = 0; i < msg.length; ++i) {
    padded[i] = msg[i];
  }
  for (int i = 0; i < padSize; ++i) {
    padded[msg.length + i] = 0;
  }
  return padded;
}