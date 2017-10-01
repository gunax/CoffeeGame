opcodes = [
  #No OP
  NOP = (cpu) ->
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4

  #load BC with constant nn
  LDBCnn = (cpu) ->
    cpu.register.C = cpu.MMU.read8(cpu.register.PC)
    cpu.register.B = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.PC += 3
    cpu.clock.m += 3
    cpu.clock.t += 12

  #load address BC with A
  LDBCmA = (cpu) ->
    BC = cpu.register.readBC()
    cpu.MMU.write8(BC, A)
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 8

  #Increment BC
  INC_BC = (cpu) ->
    cpu.register.writeBC(cpu.register.readBC()+1)
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 8

  #Increment B
  INC_B = (cpu) ->
    cpu.register.B++
    if (cpu.register.B == 256)
      cpu.register.B = 0
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4
    #TODO: set flags on these

  #Decrement B
  DEC_B = (cpu) ->
    cpu.register.B--
    if (cpu.register.B == -1)
      cpu.register.B = 255
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 4

  #Load 8-bit n into B
  LDBn = (cpu) ->
    n = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.B = n
    cpu.register.PC += 2
    cpu.clock.m += 2
    cpu.clock.t += 8

	#7
 	OPCODE_7 = (cpu) ->
 		cpu.register.PC++
 		console.log("7 unimplemented opcode")
	#8
 	OPCODE_8 = (cpu) ->
 		cpu.register.PC++
 		console.log("8 unimplemented opcode")
	#9
 	OPCODE_9 = (cpu) ->
 		cpu.register.PC++
 		console.log("9 unimplemented opcode")
	#10
 	OPCODE_10 = (cpu) ->
 		cpu.register.PC++
 		console.log("10 unimplemented opcode")
	#11
 	OPCODE_11 = (cpu) ->
 		cpu.register.PC++
 		console.log("11 unimplemented opcode")
	#12
 	OPCODE_12 = (cpu) ->
 		cpu.register.PC++
 		console.log("12 unimplemented opcode")
	#13
 	OPCODE_13 = (cpu) ->
 		cpu.register.PC++
 		console.log("13 unimplemented opcode")
	#14 load 8-bit immediate into C
  OPCODE_14 = (cpu) ->
    n = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.C = n
    cpu.register.PC += 2
    cpu.clock.m += 2
    cpu.clock.t += 8
	#15
 	OPCODE_15 = (cpu) ->
 		cpu.register.PC++
 		console.log("15 unimplemented opcode")
	#16
 	OPCODE_16 = (cpu) ->
 		cpu.register.PC++
 		console.log("16 unimplemented opcode")
	#17
 	OPCODE_17 = (cpu) ->
 		cpu.register.PC++
 		console.log("17 unimplemented opcode")
	#18
 	OPCODE_18 = (cpu) ->
 		cpu.register.PC++
 		console.log("18 unimplemented opcode")
	#19
 	OPCODE_19 = (cpu) ->
 		cpu.register.PC++
 		console.log("19 unimplemented opcode")
	#20
 	OPCODE_20 = (cpu) ->
 		cpu.register.PC++
 		console.log("20 unimplemented opcode")
	#21
 	OPCODE_21 = (cpu) ->
 		cpu.register.PC++
 		console.log("21 unimplemented opcode")
	#22
 	OPCODE_22 = (cpu) ->
 		cpu.register.PC++
 		console.log("22 unimplemented opcode")
	#23
 	OPCODE_23 = (cpu) ->
 		cpu.register.PC++
 		console.log("23 unimplemented opcode")
	#24
 	OPCODE_24 = (cpu) ->
 		cpu.register.PC++
 		console.log("24 unimplemented opcode")
	#25
 	OPCODE_25 = (cpu) ->
 		cpu.register.PC++
 		console.log("25 unimplemented opcode")
	#26
 	OPCODE_26 = (cpu) ->
 		cpu.register.PC++
 		console.log("26 unimplemented opcode")
	#27
 	OPCODE_27 = (cpu) ->
 		cpu.register.PC++
 		console.log("27 unimplemented opcode")
	#28
 	OPCODE_28 = (cpu) ->
 		cpu.register.PC++
 		console.log("28 unimplemented opcode")
	#29
 	OPCODE_29 = (cpu) ->
 		cpu.register.PC++
 		console.log("29 unimplemented opcode")
	#30
 	OPCODE_30 = (cpu) ->
 		cpu.register.PC++
 		console.log("30 unimplemented opcode")
	#31
 	OPCODE_31 = (cpu) ->
 		cpu.register.PC++
 		console.log("31 unimplemented opcode")
	#0x20 relative jump by signed immediate
 	JR_NZn = (cpu) ->

	#0x21 load 16-bit immediate into HL
 	LDHLnn = (cpu) ->
    cpu.register.L = cpu.MMU.read8(cpu.register.PC+1)
    cpu.register.H = cpu.MMU.read8(cpu.register.PC+2)
    cpu.register.PC += 3
    cpu.clock.m += 3
    cpu.clock.t += 12
	#34
 	OPCODE_34 = (cpu) ->
 		cpu.register.PC++
 		console.log("34 unimplemented opcode")
	#35
 	OPCODE_35 = (cpu) ->
 		cpu.register.PC++
 		console.log("35 unimplemented opcode")
	#36
 	OPCODE_36 = (cpu) ->
 		cpu.register.PC++
 		console.log("36 unimplemented opcode")
	#37
 	OPCODE_37 = (cpu) ->
 		cpu.register.PC++
 		console.log("37 unimplemented opcode")
	#38
 	OPCODE_38 = (cpu) ->
 		cpu.register.PC++
 		console.log("38 unimplemented opcode")
	#39
 	OPCODE_39 = (cpu) ->
 		cpu.register.PC++
 		console.log("39 unimplemented opcode")
	#40
 	OPCODE_40 = (cpu) ->
 		cpu.register.PC++
 		console.log("40 unimplemented opcode")
	#41
 	OPCODE_41 = (cpu) ->
 		cpu.register.PC++
 		console.log("41 unimplemented opcode")
	#42
 	OPCODE_42 = (cpu) ->
 		cpu.register.PC++
 		console.log("42 unimplemented opcode")
	#43
 	OPCODE_43 = (cpu) ->
 		cpu.register.PC++
 		console.log("43 unimplemented opcode")
	#44
 	OPCODE_44 = (cpu) ->
 		cpu.register.PC++
 		console.log("44 unimplemented opcode")
	#45
 	OPCODE_45 = (cpu) ->
 		cpu.register.PC++
 		console.log("45 unimplemented opcode")
	#46
 	OPCODE_46 = (cpu) ->
 		cpu.register.PC++
 		console.log("46 unimplemented opcode")
	#47
 	OPCODE_47 = (cpu) ->
 		cpu.register.PC++
 		console.log("47 unimplemented opcode")
	#48
 	OPCODE_48 = (cpu) ->
 		cpu.register.PC++
 		console.log("48 unimplemented opcode")
	#49
 	OPCODE_49 = (cpu) ->
 		cpu.register.PC++
 		console.log("49 unimplemented opcode")
	#0x32 Load A into (HL), dec HL
 	LDHLaDEC = (cpu) ->
    HL = cpu.register.readHL()
    cpu.MMU.write8(HL, cpu.register.A)
    cpu.register.writeHL(HL-1)
    cpu.register.PC += 1
    cpu.clock.m += 1
    cpu.clock.t += 8
	#51
 	OPCODE_51 = (cpu) ->
 		cpu.register.PC++
 		console.log("51 unimplemented opcode")
	#52
 	OPCODE_52 = (cpu) ->
 		cpu.register.PC++
 		console.log("52 unimplemented opcode")
	#53
 	OPCODE_53 = (cpu) ->
 		cpu.register.PC++
 		console.log("53 unimplemented opcode")
	#54
 	OPCODE_54 = (cpu) ->
 		cpu.register.PC++
 		console.log("54 unimplemented opcode")
	#55
 	OPCODE_55 = (cpu) ->
 		cpu.register.PC++
 		console.log("55 unimplemented opcode")
	#56
 	OPCODE_56 = (cpu) ->
 		cpu.register.PC++
 		console.log("56 unimplemented opcode")
	#57
 	OPCODE_57 = (cpu) ->
 		cpu.register.PC++
 		console.log("57 unimplemented opcode")
	#58
 	OPCODE_58 = (cpu) ->
 		cpu.register.PC++
 		console.log("58 unimplemented opcode")
	#59
 	OPCODE_59 = (cpu) ->
 		cpu.register.PC++
 		console.log("59 unimplemented opcode")
	#60
 	OPCODE_60 = (cpu) ->
 		cpu.register.PC++
 		console.log("60 unimplemented opcode")
	#61
 	OPCODE_61 = (cpu) ->
 		cpu.register.PC++
 		console.log("61 unimplemented opcode")
	#62
 	OPCODE_62 = (cpu) ->
 		cpu.register.PC++
 		console.log("62 unimplemented opcode")
	#63
 	OPCODE_63 = (cpu) ->
 		cpu.register.PC++
 		console.log("63 unimplemented opcode")
	#64
 	OPCODE_64 = (cpu) ->
 		cpu.register.PC++
 		console.log("64 unimplemented opcode")
	#65
 	OPCODE_65 = (cpu) ->
 		cpu.register.PC++
 		console.log("65 unimplemented opcode")
	#66
 	OPCODE_66 = (cpu) ->
 		cpu.register.PC++
 		console.log("66 unimplemented opcode")
	#67
 	OPCODE_67 = (cpu) ->
 		cpu.register.PC++
 		console.log("67 unimplemented opcode")
	#68
 	OPCODE_68 = (cpu) ->
 		cpu.register.PC++
 		console.log("68 unimplemented opcode")
	#69
 	OPCODE_69 = (cpu) ->
 		cpu.register.PC++
 		console.log("69 unimplemented opcode")
	#70
 	OPCODE_70 = (cpu) ->
 		cpu.register.PC++
 		console.log("70 unimplemented opcode")
	#71
 	OPCODE_71 = (cpu) ->
 		cpu.register.PC++
 		console.log("71 unimplemented opcode")
	#72
 	OPCODE_72 = (cpu) ->
 		cpu.register.PC++
 		console.log("72 unimplemented opcode")
	#73
 	OPCODE_73 = (cpu) ->
 		cpu.register.PC++
 		console.log("73 unimplemented opcode")
	#74
 	OPCODE_74 = (cpu) ->
 		cpu.register.PC++
 		console.log("74 unimplemented opcode")
	#75
 	OPCODE_75 = (cpu) ->
 		cpu.register.PC++
 		console.log("75 unimplemented opcode")
	#76
 	OPCODE_76 = (cpu) ->
 		cpu.register.PC++
 		console.log("76 unimplemented opcode")
	#77
 	OPCODE_77 = (cpu) ->
 		cpu.register.PC++
 		console.log("77 unimplemented opcode")
	#78
 	OPCODE_78 = (cpu) ->
 		cpu.register.PC++
 		console.log("78 unimplemented opcode")
	#79
 	OPCODE_79 = (cpu) ->
 		cpu.register.PC++
 		console.log("79 unimplemented opcode")
	#80
 	OPCODE_80 = (cpu) ->
 		cpu.register.PC++
 		console.log("80 unimplemented opcode")
	#81
 	OPCODE_81 = (cpu) ->
 		cpu.register.PC++
 		console.log("81 unimplemented opcode")
	#82
 	OPCODE_82 = (cpu) ->
 		cpu.register.PC++
 		console.log("82 unimplemented opcode")
	#83
 	OPCODE_83 = (cpu) ->
 		cpu.register.PC++
 		console.log("83 unimplemented opcode")
	#84
 	OPCODE_84 = (cpu) ->
 		cpu.register.PC++
 		console.log("84 unimplemented opcode")
	#85
 	OPCODE_85 = (cpu) ->
 		cpu.register.PC++
 		console.log("85 unimplemented opcode")
	#86
 	OPCODE_86 = (cpu) ->
 		cpu.register.PC++
 		console.log("86 unimplemented opcode")
	#87
 	OPCODE_87 = (cpu) ->
 		cpu.register.PC++
 		console.log("87 unimplemented opcode")
	#88
 	OPCODE_88 = (cpu) ->
 		cpu.register.PC++
 		console.log("88 unimplemented opcode")
	#89
 	OPCODE_89 = (cpu) ->
 		cpu.register.PC++
 		console.log("89 unimplemented opcode")
	#90
 	OPCODE_90 = (cpu) ->
 		cpu.register.PC++
 		console.log("90 unimplemented opcode")
	#91
 	OPCODE_91 = (cpu) ->
 		cpu.register.PC++
 		console.log("91 unimplemented opcode")
	#92
 	OPCODE_92 = (cpu) ->
 		cpu.register.PC++
 		console.log("92 unimplemented opcode")
	#93
 	OPCODE_93 = (cpu) ->
 		cpu.register.PC++
 		console.log("93 unimplemented opcode")
	#94
 	OPCODE_94 = (cpu) ->
 		cpu.register.PC++
 		console.log("94 unimplemented opcode")
	#95
 	OPCODE_95 = (cpu) ->
 		cpu.register.PC++
 		console.log("95 unimplemented opcode")
	#96
 	OPCODE_96 = (cpu) ->
 		cpu.register.PC++
 		console.log("96 unimplemented opcode")
	#97
 	OPCODE_97 = (cpu) ->
 		cpu.register.PC++
 		console.log("97 unimplemented opcode")
	#98
 	OPCODE_98 = (cpu) ->
 		cpu.register.PC++
 		console.log("98 unimplemented opcode")
	#99
 	OPCODE_99 = (cpu) ->
 		cpu.register.PC++
 		console.log("99 unimplemented opcode")
	#100
 	OPCODE_100 = (cpu) ->
 		cpu.register.PC++
 		console.log("100 unimplemented opcode")
	#101
 	OPCODE_101 = (cpu) ->
 		cpu.register.PC++
 		console.log("101 unimplemented opcode")
	#102
 	OPCODE_102 = (cpu) ->
 		cpu.register.PC++
 		console.log("102 unimplemented opcode")
	#103
 	OPCODE_103 = (cpu) ->
 		cpu.register.PC++
 		console.log("103 unimplemented opcode")
	#104
 	OPCODE_104 = (cpu) ->
 		cpu.register.PC++
 		console.log("104 unimplemented opcode")
	#105
 	OPCODE_105 = (cpu) ->
 		cpu.register.PC++
 		console.log("105 unimplemented opcode")
	#106
 	OPCODE_106 = (cpu) ->
 		cpu.register.PC++
 		console.log("106 unimplemented opcode")
	#107
 	OPCODE_107 = (cpu) ->
 		cpu.register.PC++
 		console.log("107 unimplemented opcode")
	#108
 	OPCODE_108 = (cpu) ->
 		cpu.register.PC++
 		console.log("108 unimplemented opcode")
	#109
 	OPCODE_109 = (cpu) ->
 		cpu.register.PC++
 		console.log("109 unimplemented opcode")
	#110
 	OPCODE_110 = (cpu) ->
 		cpu.register.PC++
 		console.log("110 unimplemented opcode")
	#111
 	OPCODE_111 = (cpu) ->
 		cpu.register.PC++
 		console.log("111 unimplemented opcode")
	#112
 	OPCODE_112 = (cpu) ->
 		cpu.register.PC++
 		console.log("112 unimplemented opcode")
	#113
 	OPCODE_113 = (cpu) ->
 		cpu.register.PC++
 		console.log("113 unimplemented opcode")
	#114
 	OPCODE_114 = (cpu) ->
 		cpu.register.PC++
 		console.log("114 unimplemented opcode")
	#115
 	OPCODE_115 = (cpu) ->
 		cpu.register.PC++
 		console.log("115 unimplemented opcode")
	#116
 	OPCODE_116 = (cpu) ->
 		cpu.register.PC++
 		console.log("116 unimplemented opcode")
	#117
 	OPCODE_117 = (cpu) ->
 		cpu.register.PC++
 		console.log("117 unimplemented opcode")
	#118
 	OPCODE_118 = (cpu) ->
 		cpu.register.PC++
 		console.log("118 unimplemented opcode")
	#119
 	OPCODE_119 = (cpu) ->
 		cpu.register.PC++
 		console.log("119 unimplemented opcode")
	#120
 	OPCODE_120 = (cpu) ->
 		cpu.register.PC++
 		console.log("120 unimplemented opcode")
	#121
 	OPCODE_121 = (cpu) ->
 		cpu.register.PC++
 		console.log("121 unimplemented opcode")
	#122
 	OPCODE_122 = (cpu) ->
 		cpu.register.PC++
 		console.log("122 unimplemented opcode")
	#123
 	OPCODE_123 = (cpu) ->
 		cpu.register.PC++
 		console.log("123 unimplemented opcode")
	#124
 	OPCODE_124 = (cpu) ->
 		cpu.register.PC++
 		console.log("124 unimplemented opcode")
	#125
 	OPCODE_125 = (cpu) ->
 		cpu.register.PC++
 		console.log("125 unimplemented opcode")
	#126
 	OPCODE_126 = (cpu) ->
 		cpu.register.PC++
 		console.log("126 unimplemented opcode")
	#127
 	OPCODE_127 = (cpu) ->
 		cpu.register.PC++
 		console.log("127 unimplemented opcode")
	#128
 	OPCODE_128 = (cpu) ->
 		cpu.register.PC++
 		console.log("128 unimplemented opcode")
	#129
 	OPCODE_129 = (cpu) ->
 		cpu.register.PC++
 		console.log("129 unimplemented opcode")
	#130
 	OPCODE_130 = (cpu) ->
 		cpu.register.PC++
 		console.log("130 unimplemented opcode")
	#131
 	OPCODE_131 = (cpu) ->
 		cpu.register.PC++
 		console.log("131 unimplemented opcode")
	#132
 	OPCODE_132 = (cpu) ->
 		cpu.register.PC++
 		console.log("132 unimplemented opcode")
	#133
 	OPCODE_133 = (cpu) ->
 		cpu.register.PC++
 		console.log("133 unimplemented opcode")
	#134
 	OPCODE_134 = (cpu) ->
 		cpu.register.PC++
 		console.log("134 unimplemented opcode")
	#135
 	OPCODE_135 = (cpu) ->
 		cpu.register.PC++
 		console.log("135 unimplemented opcode")
	#136
 	OPCODE_136 = (cpu) ->
 		cpu.register.PC++
 		console.log("136 unimplemented opcode")
	#137
 	OPCODE_137 = (cpu) ->
 		cpu.register.PC++
 		console.log("137 unimplemented opcode")
	#138
 	OPCODE_138 = (cpu) ->
 		cpu.register.PC++
 		console.log("138 unimplemented opcode")
	#139
 	OPCODE_139 = (cpu) ->
 		cpu.register.PC++
 		console.log("139 unimplemented opcode")
	#140
 	OPCODE_140 = (cpu) ->
 		cpu.register.PC++
 		console.log("140 unimplemented opcode")
	#141
 	OPCODE_141 = (cpu) ->
 		cpu.register.PC++
 		console.log("141 unimplemented opcode")
	#142
 	OPCODE_142 = (cpu) ->
 		cpu.register.PC++
 		console.log("142 unimplemented opcode")
	#143
 	OPCODE_143 = (cpu) ->
 		cpu.register.PC++
 		console.log("143 unimplemented opcode")
	#144
 	OPCODE_144 = (cpu) ->
 		cpu.register.PC++
 		console.log("144 unimplemented opcode")
	#145
 	OPCODE_145 = (cpu) ->
 		cpu.register.PC++
 		console.log("145 unimplemented opcode")
	#146
 	OPCODE_146 = (cpu) ->
 		cpu.register.PC++
 		console.log("146 unimplemented opcode")
	#147
 	OPCODE_147 = (cpu) ->
 		cpu.register.PC++
 		console.log("147 unimplemented opcode")
	#148
 	OPCODE_148 = (cpu) ->
 		cpu.register.PC++
 		console.log("148 unimplemented opcode")
	#149
 	OPCODE_149 = (cpu) ->
 		cpu.register.PC++
 		console.log("149 unimplemented opcode")
	#150
 	OPCODE_150 = (cpu) ->
 		cpu.register.PC++
 		console.log("150 unimplemented opcode")
	#151
 	OPCODE_151 = (cpu) ->
 		cpu.register.PC++
 		console.log("151 unimplemented opcode")
	#152
 	OPCODE_152 = (cpu) ->
 		cpu.register.PC++
 		console.log("152 unimplemented opcode")
	#153
 	OPCODE_153 = (cpu) ->
 		cpu.register.PC++
 		console.log("153 unimplemented opcode")
	#154
 	OPCODE_154 = (cpu) ->
 		cpu.register.PC++
 		console.log("154 unimplemented opcode")
	#155
 	OPCODE_155 = (cpu) ->
 		cpu.register.PC++
 		console.log("155 unimplemented opcode")
	#156
 	OPCODE_156 = (cpu) ->
 		cpu.register.PC++
 		console.log("156 unimplemented opcode")
	#157
 	OPCODE_157 = (cpu) ->
 		cpu.register.PC++
 		console.log("157 unimplemented opcode")
	#158
 	OPCODE_158 = (cpu) ->
 		cpu.register.PC++
 		console.log("158 unimplemented opcode")
	#159
 	OPCODE_159 = (cpu) ->
 		cpu.register.PC++
 		console.log("159 unimplemented opcode")
	#160
 	OPCODE_160 = (cpu) ->
 		cpu.register.PC++
 		console.log("160 unimplemented opcode")
	#161
 	OPCODE_161 = (cpu) ->
 		cpu.register.PC++
 		console.log("161 unimplemented opcode")
	#162
 	OPCODE_162 = (cpu) ->
 		cpu.register.PC++
 		console.log("162 unimplemented opcode")
	#163
 	OPCODE_163 = (cpu) ->
 		cpu.register.PC++
 		console.log("163 unimplemented opcode")
	#164
 	OPCODE_164 = (cpu) ->
 		cpu.register.PC++
 		console.log("164 unimplemented opcode")
	#165
 	OPCODE_165 = (cpu) ->
 		cpu.register.PC++
 		console.log("165 unimplemented opcode")
	#166
 	OPCODE_166 = (cpu) ->
 		cpu.register.PC++
 		console.log("166 unimplemented opcode")
	#167
 	OPCODE_167 = (cpu) ->
 		cpu.register.PC++
 		console.log("167 unimplemented opcode")
	#168
 	OPCODE_168 = (cpu) ->
 		cpu.register.PC++
 		console.log("168 unimplemented opcode")
	#169
 	OPCODE_169 = (cpu) ->
 		cpu.register.PC++
 		console.log("169 unimplemented opcode")
	#170
 	OPCODE_170 = (cpu) ->
 		cpu.register.PC++
 		console.log("170 unimplemented opcode")
	#171
 	OPCODE_171 = (cpu) ->
 		cpu.register.PC++
 		console.log("171 unimplemented opcode")
	#172
 	OPCODE_172 = (cpu) ->
 		cpu.register.PC++
 		console.log("172 unimplemented opcode")
	#173
 	OPCODE_173 = (cpu) ->
 		cpu.register.PC++
 		console.log("173 unimplemented opcode")
	#174
 	OPCODE_174 = (cpu) ->
 		cpu.register.PC++
 		console.log("174 unimplemented opcode")

	#175 XOR A against A
  OPCODE_175 = (cpu) ->
    r = cpu.register.A^cpu.register.A
    cpu.register.A = r
    cpu.register.F = if r then 0 else 0x80
    cpu.register.PC++
    cpu.clock.m += 1
    cpu.clock.t += 4

	#176
 	OPCODE_176 = (cpu) ->
 		cpu.register.PC++
 		console.log("176 unimplemented opcode")
	#177
 	OPCODE_177 = (cpu) ->
 		cpu.register.PC++
 		console.log("177 unimplemented opcode")
	#178
 	OPCODE_178 = (cpu) ->
 		cpu.register.PC++
 		console.log("178 unimplemented opcode")
	#179
 	OPCODE_179 = (cpu) ->
 		cpu.register.PC++
 		console.log("179 unimplemented opcode")
	#180
 	OPCODE_180 = (cpu) ->
 		cpu.register.PC++
 		console.log("180 unimplemented opcode")
	#181
 	OPCODE_181 = (cpu) ->
 		cpu.register.PC++
 		console.log("181 unimplemented opcode")
	#182
 	OPCODE_182 = (cpu) ->
 		cpu.register.PC++
 		console.log("182 unimplemented opcode")
	#183
 	OPCODE_183 = (cpu) ->
 		cpu.register.PC++
 		console.log("183 unimplemented opcode")
	#184
 	OPCODE_184 = (cpu) ->
 		cpu.register.PC++
 		console.log("184 unimplemented opcode")
	#185
 	OPCODE_185 = (cpu) ->
 		cpu.register.PC++
 		console.log("185 unimplemented opcode")
	#186
 	OPCODE_186 = (cpu) ->
 		cpu.register.PC++
 		console.log("186 unimplemented opcode")
	#187
 	OPCODE_187 = (cpu) ->
 		cpu.register.PC++
 		console.log("187 unimplemented opcode")
	#188
 	OPCODE_188 = (cpu) ->
 		cpu.register.PC++
 		console.log("188 unimplemented opcode")
	#189
 	OPCODE_189 = (cpu) ->
 		cpu.register.PC++
 		console.log("189 unimplemented opcode")
	#190
 	OPCODE_190 = (cpu) ->
 		cpu.register.PC++
 		console.log("190 unimplemented opcode")
	#191
 	OPCODE_191 = (cpu) ->
 		cpu.register.PC++
 		console.log("191 unimplemented opcode")
	#192
 	OPCODE_192 = (cpu) ->
 		cpu.register.PC++
 		console.log("192 unimplemented opcode")
	#193
 	OPCODE_193 = (cpu) ->
 		cpu.register.PC++
 		console.log("193 unimplemented opcode")
	#194
 	OPCODE_194 = (cpu) ->
 		cpu.register.PC++
 		console.log("194 unimplemented opcode")

	#0xC3 Jump to 16-bit immediate
 	OPCODE_195 = (cpu) ->
    loc = cpu.MMU.read16(cpu.register.PC+1)
    cpu.register.PC = loc
    cpu.clock.m += 3
    cpu.clock.t += 16

	#196
 	OPCODE_196 = (cpu) ->
 		cpu.register.PC++
 		console.log("196 unimplemented opcode")
	#197
 	OPCODE_197 = (cpu) ->
 		cpu.register.PC++
 		console.log("197 unimplemented opcode")
	#198
 	OPCODE_198 = (cpu) ->
 		cpu.register.PC++
 		console.log("198 unimplemented opcode")
	#199
 	OPCODE_199 = (cpu) ->
 		cpu.register.PC++
 		console.log("199 unimplemented opcode")
	#200
 	OPCODE_200 = (cpu) ->
 		cpu.register.PC++
 		console.log("200 unimplemented opcode")
	#201
 	OPCODE_201 = (cpu) ->
 		cpu.register.PC++
 		console.log("201 unimplemented opcode")
	#202
  OPCODE_202 = (cpu) ->
    cpu.register.PC++
    console.log("202 unimplemented opcode")
	#203
 	OPCODE_203 = (cpu) ->
    cpu.register.PC++
    console.log("203 unimplemented opcode")
    console.log("THIS IS THE CB PREFIX")
	#204
 	OPCODE_204 = (cpu) ->
 		cpu.register.PC++
 		console.log("204 unimplemented opcode")
	#205
 	OPCODE_205 = (cpu) ->
 		cpu.register.PC++
 		console.log("205 unimplemented opcode")
	#206
 	OPCODE_206 = (cpu) ->
 		cpu.register.PC++
 		console.log("206 unimplemented opcode")
	#207
 	OPCODE_207 = (cpu) ->
 		cpu.register.PC++
 		console.log("207 unimplemented opcode")
	#208
 	OPCODE_208 = (cpu) ->
 		cpu.register.PC++
 		console.log("208 unimplemented opcode")
	#209
 	OPCODE_209 = (cpu) ->
 		cpu.register.PC++
 		console.log("209 unimplemented opcode")
	#210
 	OPCODE_210 = (cpu) ->
 		cpu.register.PC++
 		console.log("210 unimplemented opcode")
	#211
 	OPCODE_211 = (cpu) ->
 		cpu.register.PC++
 		console.log("211 unimplemented opcode")
	#212
 	OPCODE_212 = (cpu) ->
 		cpu.register.PC++
 		console.log("212 unimplemented opcode")
	#213
 	OPCODE_213 = (cpu) ->
 		cpu.register.PC++
 		console.log("213 unimplemented opcode")
	#214
 	OPCODE_214 = (cpu) ->
 		cpu.register.PC++
 		console.log("214 unimplemented opcode")
	#215
 	OPCODE_215 = (cpu) ->
 		cpu.register.PC++
 		console.log("215 unimplemented opcode")
	#216
 	OPCODE_216 = (cpu) ->
 		cpu.register.PC++
 		console.log("216 unimplemented opcode")
	#217
 	OPCODE_217 = (cpu) ->
 		cpu.register.PC++
 		console.log("217 unimplemented opcode")
	#218
 	OPCODE_218 = (cpu) ->
 		cpu.register.PC++
 		console.log("218 unimplemented opcode")
	#219
 	OPCODE_219 = (cpu) ->
 		cpu.register.PC++
 		console.log("219 unimplemented opcode")
	#220
 	OPCODE_220 = (cpu) ->
 		cpu.register.PC++
 		console.log("220 unimplemented opcode")
	#221
 	OPCODE_221 = (cpu) ->
 		cpu.register.PC++
 		console.log("221 unimplemented opcode")
	#222
 	OPCODE_222 = (cpu) ->
 		cpu.register.PC++
 		console.log("222 unimplemented opcode")
	#223
 	OPCODE_223 = (cpu) ->
 		cpu.register.PC++
 		console.log("223 unimplemented opcode")
	#224
 	OPCODE_224 = (cpu) ->
 		cpu.register.PC++
 		console.log("224 unimplemented opcode")
	#225
 	OPCODE_225 = (cpu) ->
 		cpu.register.PC++
 		console.log("225 unimplemented opcode")
	#226
 	OPCODE_226 = (cpu) ->
 		cpu.register.PC++
 		console.log("226 unimplemented opcode")
	#227
 	OPCODE_227 = (cpu) ->
 		cpu.register.PC++
 		console.log("227 unimplemented opcode")
	#228
 	OPCODE_228 = (cpu) ->
 		cpu.register.PC++
 		console.log("228 unimplemented opcode")
	#229
 	OPCODE_229 = (cpu) ->
 		cpu.register.PC++
 		console.log("229 unimplemented opcode")
	#230
 	OPCODE_230 = (cpu) ->
 		cpu.register.PC++
 		console.log("230 unimplemented opcode")
	#231
 	OPCODE_231 = (cpu) ->
 		cpu.register.PC++
 		console.log("231 unimplemented opcode")
	#232
 	OPCODE_232 = (cpu) ->
 		cpu.register.PC++
 		console.log("232 unimplemented opcode")
	#233
 	OPCODE_233 = (cpu) ->
 		cpu.register.PC++
 		console.log("233 unimplemented opcode")
	#234
 	OPCODE_234 = (cpu) ->
 		cpu.register.PC++
 		console.log("234 unimplemented opcode")
	#235
 	OPCODE_235 = (cpu) ->
 		cpu.register.PC++
 		console.log("235 unimplemented opcode")
	#236
 	OPCODE_236 = (cpu) ->
 		cpu.register.PC++
 		console.log("236 unimplemented opcode")
	#237
 	OPCODE_237 = (cpu) ->
 		cpu.register.PC++
 		console.log("237 unimplemented opcode")
	#238
 	OPCODE_238 = (cpu) ->
 		cpu.register.PC++
 		console.log("238 unimplemented opcode")
	#239
 	OPCODE_239 = (cpu) ->
 		cpu.register.PC++
 		console.log("239 unimplemented opcode")
	#240
 	OPCODE_240 = (cpu) ->
 		cpu.register.PC++
 		console.log("240 unimplemented opcode")
	#241
 	OPCODE_241 = (cpu) ->
 		cpu.register.PC++
 		console.log("241 unimplemented opcode")
	#242
 	OPCODE_242 = (cpu) ->
 		cpu.register.PC++
 		console.log("242 unimplemented opcode")
	#243
 	OPCODE_243 = (cpu) ->
 		cpu.register.PC++
 		console.log("243 unimplemented opcode")
	#244
 	OPCODE_244 = (cpu) ->
 		cpu.register.PC++
 		console.log("244 unimplemented opcode")
	#245
 	OPCODE_245 = (cpu) ->
 		cpu.register.PC++
 		console.log("245 unimplemented opcode")
	#246
 	OPCODE_246 = (cpu) ->
 		cpu.register.PC++
 		console.log("246 unimplemented opcode")
	#247
 	OPCODE_247 = (cpu) ->
 		cpu.register.PC++
 		console.log("247 unimplemented opcode")
	#248
 	OPCODE_248 = (cpu) ->
 		cpu.register.PC++
 		console.log("248 unimplemented opcode")
	#249
 	OPCODE_249 = (cpu) ->
 		cpu.register.PC++
 		console.log("249 unimplemented opcode")
	#250
 	OPCODE_250 = (cpu) ->
 		cpu.register.PC++
 		console.log("250 unimplemented opcode")
	#251
 	OPCODE_251 = (cpu) ->
 		cpu.register.PC++
 		console.log("251 unimplemented opcode")
	#252
 	OPCODE_252 = (cpu) ->
 		cpu.register.PC++
 		console.log("252 unimplemented opcode")
	#253
 	OPCODE_253 = (cpu) ->
 		cpu.register.PC++
 		console.log("253 unimplemented opcode")
	#254
 	OPCODE_254 = (cpu) ->
 		cpu.register.PC++
 		console.log("254 unimplemented opcode")
	#255
 	OPCODE_255 = (cpu) ->
 		cpu.register.PC++
 		console.log("255 unimplemented opcode")

]
