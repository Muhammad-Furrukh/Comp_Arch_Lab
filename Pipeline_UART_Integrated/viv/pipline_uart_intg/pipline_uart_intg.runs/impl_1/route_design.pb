
Q
Command: %s
53*	vivadotcl2 
route_design2default:defaultZ4-113h px� 
�
@Attempting to get a license for feature '%s' and/or device '%s'
308*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-347h px� 
�
0Got license for feature '%s' and/or device '%s'
310*common2"
Implementation2default:default2
xc7a100t2default:defaultZ17-349h px� 
p
,Running DRC as a precondition to command %s
22*	vivadotcl2 
route_design2default:defaultZ4-22h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
V
DRC finished with %s
79*	vivadotcl2
0 Errors2default:defaultZ4-198h px� 
e
BPlease refer to the DRC report (report_drc) for more information.
80*	vivadotclZ4-199h px� 
V

Starting %s Task
103*constraints2
Routing2default:defaultZ18-103h px� 
}
BMultithreading enabled for route_design using a maximum of %s CPUs17*	routeflow2
22default:defaultZ35-254h px� 
p

Phase %s%s
101*constraints2
1 2default:default2#
Build RT Design2default:defaultZ18-101h px� 
B
-Phase 1 Build RT Design | Checksum: 29afb99f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:37 ; elapsed = 00:01:26 . Memory (MB): peak = 1447.754 ; gain = 108.9732default:defaulth px� 
v

Phase %s%s
101*constraints2
2 2default:default2)
Router Initialization2default:defaultZ18-101h px� 
o

Phase %s%s
101*constraints2
2.1 2default:default2 
Create Timer2default:defaultZ18-101h px� 
A
,Phase 2.1 Create Timer | Checksum: 29afb99f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:38 ; elapsed = 00:01:27 . Memory (MB): peak = 1447.754 ; gain = 108.9732default:defaulth px� 
{

Phase %s%s
101*constraints2
2.2 2default:default2,
Fix Topology Constraints2default:defaultZ18-101h px� 
M
8Phase 2.2 Fix Topology Constraints | Checksum: 29afb99f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:39 ; elapsed = 00:01:28 . Memory (MB): peak = 1455.133 ; gain = 116.3522default:defaulth px� 
t

Phase %s%s
101*constraints2
2.3 2default:default2%
Pre Route Cleanup2default:defaultZ18-101h px� 
F
1Phase 2.3 Pre Route Cleanup | Checksum: 29afb99f
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:39 ; elapsed = 00:01:28 . Memory (MB): peak = 1455.133 ; gain = 116.3522default:defaulth px� 
p

Phase %s%s
101*constraints2
2.4 2default:default2!
Update Timing2default:defaultZ18-101h px� 
C
.Phase 2.4 Update Timing | Checksum: 1a899ea7e
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:01:56 ; elapsed = 00:01:39 . Memory (MB): peak = 1488.523 ; gain = 149.7422default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-2.788 | TNS=-1088.772| WHS=-0.141 | THS=-3.617 |
2default:defaultZ35-416h px� 
I
4Phase 2 Router Initialization | Checksum: 17115e5e6
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:02 ; elapsed = 00:01:42 . Memory (MB): peak = 1488.523 ; gain = 149.7422default:defaulth px� 
p

Phase %s%s
101*constraints2
3 2default:default2#
Initial Routing2default:defaultZ18-101h px� 
C
.Phase 3 Initial Routing | Checksum: 1d0076901
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:02:14 ; elapsed = 00:01:48 . Memory (MB): peak = 1491.957 ; gain = 153.1762default:defaulth px� 
s

Phase %s%s
101*constraints2
4 2default:default2&
Rip-up And Reroute2default:defaultZ18-101h px� 
u

Phase %s%s
101*constraints2
4.1 2default:default2&
Global Iteration 02default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-3.048 | TNS=-3398.084| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 4.1 Global Iteration 0 | Checksum: 1640d6095
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:04:11 ; elapsed = 00:02:59 . Memory (MB): peak = 1491.957 ; gain = 153.1762default:defaulth px� 
u

Phase %s%s
101*constraints2
4.2 2default:default2&
Global Iteration 12default:defaultZ18-101h px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-3.060 | TNS=-3398.793| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
H
3Phase 4.2 Global Iteration 1 | Checksum: 1c6d68399
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:04:55 ; elapsed = 00:03:24 . Memory (MB): peak = 1491.957 ; gain = 153.1762default:defaulth px� 
F
1Phase 4 Rip-up And Reroute | Checksum: 1c6d68399
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:04:56 ; elapsed = 00:03:24 . Memory (MB): peak = 1491.957 ; gain = 153.1762default:defaulth px� 
|

Phase %s%s
101*constraints2
5 2default:default2/
Delay and Skew Optimization2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
5.1 2default:default2!
Delay CleanUp2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
5.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
E
0Phase 5.1.1 Update Timing | Checksum: 1b2d703d7
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:04:58 ; elapsed = 00:03:25 . Memory (MB): peak = 1491.957 ; gain = 153.1762default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-3.041 | TNS=-3314.804| WHS=N/A    | THS=N/A    |
2default:defaultZ35-416h px� 
B
-Phase 5.1 Delay CleanUp | Checksum: fbc68698
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:46 ; elapsed = 00:03:51 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
z

Phase %s%s
101*constraints2
5.2 2default:default2+
Clock Skew Optimization2default:defaultZ18-101h px� 
L
7Phase 5.2 Clock Skew Optimization | Checksum: fbc68698
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:46 ; elapsed = 00:03:51 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
N
9Phase 5 Delay and Skew Optimization | Checksum: fbc68698
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:47 ; elapsed = 00:03:51 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
n

Phase %s%s
101*constraints2
6 2default:default2!
Post Hold Fix2default:defaultZ18-101h px� 
p

Phase %s%s
101*constraints2
6.1 2default:default2!
Hold Fix Iter2default:defaultZ18-101h px� 
r

Phase %s%s
101*constraints2
6.1.1 2default:default2!
Update Timing2default:defaultZ18-101h px� 
D
/Phase 6.1.1 Update Timing | Checksum: abe4323c
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:48 ; elapsed = 00:03:52 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
�
Intermediate Timing Summary %s164*route2L
8| WNS=-3.041 | TNS=-3132.909| WHS=0.111  | THS=0.000  |
2default:defaultZ35-416h px� 
B
-Phase 6.1 Hold Fix Iter | Checksum: abe4323c
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:49 ; elapsed = 00:03:52 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
@
+Phase 6 Post Hold Fix | Checksum: abe4323c
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:49 ; elapsed = 00:03:52 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
o

Phase %s%s
101*constraints2
7 2default:default2"
Route finalize2default:defaultZ18-101h px� 
A
,Phase 7 Route finalize | Checksum: eadcc63a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:49 ; elapsed = 00:03:52 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
v

Phase %s%s
101*constraints2
8 2default:default2)
Verifying routed nets2default:defaultZ18-101h px� 
H
3Phase 8 Verifying routed nets | Checksum: eadcc63a
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:49 ; elapsed = 00:03:53 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
r

Phase %s%s
101*constraints2
9 2default:default2%
Depositing Routes2default:defaultZ18-101h px� 
E
0Phase 9 Depositing Routes | Checksum: 12bbee079
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:52 ; elapsed = 00:03:56 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
t

Phase %s%s
101*constraints2
10 2default:default2&
Post Router Timing2default:defaultZ18-101h px� 
�
Estimated Timing Summary %s
57*route2L
8| WNS=-3.041 | TNS=-3132.909| WHS=0.111  | THS=0.000  |
2default:defaultZ35-57h px� 
B
!Router estimated timing not met.
128*routeZ35-328h px� 
G
2Phase 10 Post Router Timing | Checksum: 12bbee079
*commonh px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:52 ; elapsed = 00:03:56 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
@
Router Completed Successfully
2*	routeflowZ35-16h px� 
�

%s
*constraints2q
]Time (s): cpu = 00:05:52 ; elapsed = 00:03:56 . Memory (MB): peak = 1537.781 ; gain = 199.0002default:defaulth px� 
Z
Releasing license: %s
83*common2"
Implementation2default:defaultZ17-83h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
652default:default2
12default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
route_design2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
route_design: 2default:default2
00:05:592default:default2
00:04:002default:default2
1537.7812default:default2
199.0002default:defaultZ17-268h px� 
H
&Writing timing data to binary archive.266*timingZ38-480h px� 
D
Writing placer database...
1603*designutilsZ20-1893h px� 
=
Writing XDEF routing.
211*designutilsZ20-211h px� 
J
#Writing XDEF routing logical nets.
209*designutilsZ20-209h px� 
J
#Writing XDEF routing special nets.
210*designutilsZ20-210h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2)
Write XDEF Complete: 2default:default2
00:00:062default:default2
00:00:032default:default2
1537.7812default:default2
0.0002default:defaultZ17-268h px� 
�
 The %s '%s' has been generated.
621*common2

checkpoint2default:default2�
�D:/Documents/UET Courses/6th Semester/Computer Architecture/Lab/Pipeline_UART_Integrated/viv/pipline_uart_intg/pipline_uart_intg.runs/impl_1/PMCP_routed.dcp2default:defaultZ17-1381h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2&
write_checkpoint: 2default:default2
00:00:082default:default2
00:00:062default:default2
1537.7812default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2u
aExecuting : report_drc -file PMCP_drc_routed.rpt -pb PMCP_drc_routed.pb -rpx PMCP_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2h
Treport_drc -file PMCP_drc_routed.rpt -pb PMCP_drc_routed.pb -rpx PMCP_drc_routed.rpx2default:defaultZ4-113h px� 
P
Running DRC with %s threads
24*drc2
22default:defaultZ23-27h px� 
�
#The results of DRC are in file %s.
168*coretcl2�
�D:/Documents/UET Courses/6th Semester/Computer Architecture/Lab/Pipeline_UART_Integrated/viv/pipline_uart_intg/pipline_uart_intg.runs/impl_1/PMCP_drc_routed.rpt�D:/Documents/UET Courses/6th Semester/Computer Architecture/Lab/Pipeline_UART_Integrated/viv/pipline_uart_intg/pipline_uart_intg.runs/impl_1/PMCP_drc_routed.rpt2default:default8Z2-168h px� 
\
%s completed successfully
29*	vivadotcl2

report_drc2default:defaultZ4-42h px� 
�
%s4*runtcl2�
�Executing : report_methodology -file PMCP_methodology_drc_routed.rpt -pb PMCP_methodology_drc_routed.pb -rpx PMCP_methodology_drc_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2�
�report_methodology -file PMCP_methodology_drc_routed.rpt -pb PMCP_methodology_drc_routed.pb -rpx PMCP_methodology_drc_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
Y
$Running Methodology with %s threads
74*drc2
22default:defaultZ23-133h px� 
�
2The results of Report Methodology are in file %s.
450*coretcl2�
�D:/Documents/UET Courses/6th Semester/Computer Architecture/Lab/Pipeline_UART_Integrated/viv/pipline_uart_intg/pipline_uart_intg.runs/impl_1/PMCP_methodology_drc_routed.rpt�D:/Documents/UET Courses/6th Semester/Computer Architecture/Lab/Pipeline_UART_Integrated/viv/pipline_uart_intg/pipline_uart_intg.runs/impl_1/PMCP_methodology_drc_routed.rpt2default:default8Z2-1520h px� 
d
%s completed successfully
29*	vivadotcl2&
report_methodology2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2(
report_methodology: 2default:default2
00:00:142default:default2
00:00:082default:default2
1537.7812default:default2
0.0002default:defaultZ17-268h px� 
�
%s4*runtcl2�
qExecuting : report_power -file PMCP_power_routed.rpt -pb PMCP_power_summary_routed.pb -rpx PMCP_power_routed.rpx
2default:defaulth px� 
�
Command: %s
53*	vivadotcl2x
dreport_power -file PMCP_power_routed.rpt -pb PMCP_power_summary_routed.pb -rpx PMCP_power_routed.rpx2default:defaultZ4-113h px� 
E
%Done setting XDC timing constraints.
35*timingZ38-35h px� 
K
,Running Vector-less Activity Propagation...
51*powerZ33-51h px� 
P
3
Finished Running Vector-less Activity Propagation
1*powerZ33-1h px� 
�
G%s Infos, %s Warnings, %s Critical Warnings and %s Errors encountered.
28*	vivadotcl2
772default:default2
12default:default2
02default:default2
02default:defaultZ4-41h px� 
^
%s completed successfully
29*	vivadotcl2 
report_power2default:defaultZ4-42h px� 
�
I%sTime (s): cpu = %s ; elapsed = %s . Memory (MB): peak = %s ; gain = %s
268*common2"
report_power: 2default:default2
00:00:172default:default2
00:00:112default:default2
1560.8242default:default2
23.0432default:defaultZ17-268h px� 
�
%s4*runtcl2i
UExecuting : report_route_status -file PMCP_route_status.rpt -pb PMCP_route_status.pb
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_timing_summary -max_paths 10 -file PMCP_timing_summary_routed.rpt -pb PMCP_timing_summary_routed.pb -rpx PMCP_timing_summary_routed.rpx -warn_on_violation 
2default:defaulth px� 
�
UpdateTimingParams:%s.
91*timing2R
> Speed grade: -1, Delay Type: min_max, Timing Stage: Requireds2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px� 
�
rThe design failed to meet the timing requirements. Please see the %s report for details on the timing violations.
188*timing2"
timing summary2default:defaultZ38-282h px� 
}
%s4*runtcl2a
MExecuting : report_incremental_reuse -file PMCP_incremental_reuse_routed.rpt
2default:defaulth px� 
x
TNo incremental reuse to report, no incremental placement and routing data was found.278*	vivadotclZ4-545h px� 
}
%s4*runtcl2a
MExecuting : report_clock_utilization -file PMCP_clock_utilization_routed.rpt
2default:defaulth px� 
�
%s4*runtcl2�
�Executing : report_bus_skew -warn_on_violation -file PMCP_bus_skew_routed.rpt -pb PMCP_bus_skew_routed.pb -rpx PMCP_bus_skew_routed.rpx
2default:defaulth px� 
�
UpdateTimingParams:%s.
91*timing2R
> Speed grade: -1, Delay Type: min_max, Timing Stage: Requireds2default:defaultZ38-91h px� 
|
CMultithreading enabled for timing update using a maximum of %s CPUs155*timing2
22default:defaultZ38-191h px� 


End Record