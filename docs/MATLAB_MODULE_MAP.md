# MATLAB 모듈 구성도

## 실행 흐름

`main.m` → 공통 설정 → 캠퍼스 데이터 → 사용자 격자 → 링크별 전력 → SINR → 전송률·통계 → 그림

## 파일과 데이터 전달

| 파일 | 역할 | 입력 | 출력 |
|---|---|---|---|
| `src/main.m` | 모듈을 순서대로 호출 | 없음 | 실험 결과 |
| `src/config/projectConfig.m` | 실험 공통 가정 관리 | 없음 | `cfg` 구조체 |
| `src/data/campusData.m` | 조사한 캠퍼스와 기지국 좌표 보관 | 없음 | `campus` 구조체 |
| `src/geometry/buildUserGrid.m` | 캠퍼스 영역 안의 중복 없는 평가 위치 생성 | `campus.evalRegions`, 격자 간격 | N×2 `[x y]` 위치 |
| `src/model/calcNoisePower.m` | 대역폭 전체의 열잡음 계산 | 대역폭(Hz), 잡음지수(dB) | 잡음(dBm) |
| `src/model/calcPathlossUMa.m` | UMa LOS/NLOS 경로손실 계산 | 2D·3D 거리(m), 주파수(GHz), 높이(m), LOS 여부 | 경로손실(dB) |
| `src/model/calcSectorGain.m` | 수평 섹터 안테나 이득 계산 | 사용자 방위각, 섹터 방향 | 안테나 이득(dB) |
| `src/model/isBlockedByBuildings.m` | 건물 사각형이 링크를 가리는지 근사 판정 | 기지국·사용자 좌표, 건물 사각형 | LOS/NLOS 판정 |
| `src/model/calcSinr.m` | 가장 강한 서빙 섹터와 간섭 합산 | 수신전력(dBm), 잡음(dBm) | 선형 SINR, dB SINR |
| `src/metrics/calcRate.m` | Shannon 전송률 근사 계산 | 대역폭(Hz), 선형 SINR | 전송률(bit/s) |
| `src/metrics/summarizeResults.m` | 평균·중앙값·하위 5%와 CDF 표본 계산 | 위치별 전송률(bit/s) | 요약 구조체 |
| `src/plots/plotResults.m` | SINR 지도와 전송률 CDF 표시 | 위치·SINR·요약·캠퍼스 데이터 | 그림 |
| `src/experiments/evaluateCampus.m` | 모든 사용자 위치와 기지국 섹터의 링크 계산 | 사용자 위치, `campus`, `cfg` | 위치별 SINR·전송률 |

## 공통 단위와 꼭 알아야 할 개념

모듈 사이의 무선 전력은 dBm으로 전달합니다. 전력을 더할 때는 선형 전력으로 변환해야 합니다. 거리는 m, UMa 식의 주파수는 GHz, 대역폭은 Hz, 전송률은 bit/s입니다.

1. 수신전력: `Prx_dBm = Ptx_dBm + 안테나이득_dB - 경로손실_dB - 실내손실_dB`
2. SINR: 선형 전력에서 `S / (I + N)`으로 계산합니다. dBm 수치를 바로 더하면 안 됩니다.
3. 열잡음: `-174 + 10*log10(BW_Hz) + NF_dB` dBm
4. 전송률: `BW_Hz * log2(1 + SINR_linear)` bit/s. 실제 측정속도가 아니라 모델의 근사값입니다.
5. 통제 실험에서는 지정한 변수만 바꿉니다. 중앙값은 중간 위치, 하위 5%는 품질이 낮은 위치를 요약합니다.

## 초안에서 옮기며 확인할 점

- 제공된 원본은 `legacy/Campus_original.m`에 보존했습니다. 순천향대 캠퍼스 좌표·건물 구역이 포함되어 있어 세종대 실험에 그대로 쓰면 안 됩니다.
- 원본의 4 GHz / 5 MHz 설정은 필수 비교 조건이 아닙니다.
- 원본의 `-174*1000` 잡음 계산은 단위가 잘못되어 `calcNoisePower`로 대체했습니다.
- 위치 중복, 투과손실, 하위 5% 집계, 용량과 기지국 처리량 구분을 다시 확인해야 합니다.

## 결과를 만들기 전에 채울 데이터

`src/data/campusData.m`에 미터 기준 좌표계, 평가 영역, 건물 사각형, 서비스 기지국과 주변 동일 대역 간섭 기지국을 입력합니다. 자료 출처와 조사일도 기록합니다. `cfg.o2iLossDb`에는 팀이 선택한 실내 손실 가정을 입력합니다. 현재 LOS/NLOS 판정은 건물 사각형을 이용한 근사이고, 실내 손실은 하나의 공통값입니다. 발표에서 이 단순화를 밝혀야 합니다. Shadow fading과 수직 안테나 패턴은 아직 구현하지 않았습니다.
