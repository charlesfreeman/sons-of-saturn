#
# Please do not edit anything in this script
#
# Just use the editor to change everything you want
#
extends Node

var scenes: Dictionary = {"AudioStreamPlayer":{"sections":[],"value":"res://sound_streams/AudioStreamPlayer.tscn"},"CharacterRect":{"sections":[],"value":"res://conversation_pov/CharacterRect.tscn"},"ClickToEnter":{"sections":[],"value":"res://roaming_pov/ClickToEnter.tscn"},"ClickToSearch":{"sections":[],"value":"res://roaming_pov/ClickToSearch.tscn"},"ContinueButton":{"sections":[],"value":"res://dialogue_system/ContinueButton.tscn"},"ConvoSoundEffect":{"sections":[],"value":"res://conversation_pov/ConvoSoundEffect.tscn"},"ConvoTransitionScreen":{"sections":[],"value":"res://conversation_pov/ConvoTransitionScreen.tscn"},"DescPopUp":{"sections":[],"value":"res://roaming_pov/DescPopUp.tscn"},"Dialogue":{"sections":[],"value":"res://dialogue_system/Dialogue.tscn"},"DialogueOption":{"sections":[],"value":"res://dialogue_system/DialogueOption.tscn"},"DocPopUp":{"sections":[],"value":"res://roaming_pov/DocPopUp.tscn"},"Documents":{"sections":[],"value":"res://conversation_pov/Documents.tscn"},"DynamicBG":{"sections":[],"value":"res://intro/intro_convo/DynamicBG.tscn"},"InvSlot":{"sections":[],"value":"res://roaming_pov/InvSlot.tscn"},"LogBook":{"sections":[],"value":"res://infirmary/log_book/LogBook.tscn"},"MDM":{"sections":[],"value":"res://sounds/MDM.tscn"},"MDS":{"sections":[],"value":"res://sounds/MDS.tscn"},"PartyMember":{"sections":[],"value":"res://roaming_pov/PartyMember.tscn"},"PoV":{"sections":[],"value":"res://roaming_pov/PoV.tscn"},"PopUp":{"sections":[],"value":"res://roaming_pov/PopUp.tscn"},"PostOfficeMural":{"sections":[],"value":"res://infirmary/post_office/PostOfficeMural.tscn"},"Quote":{"sections":["Intro"],"value":"res://intro/quote/Quote.tscn"},"Save":{"sections":[],"value":"res://roaming_pov/Save.tscn"},"SpokenLine":{"sections":[],"value":"res://dialogue_system/SpokenLine.tscn"},"SpokenLineNarrator":{"sections":[],"value":"res://dialogue_system/SpokenLineNarrator.tscn"},"SpokenLineNoChar":{"sections":[],"value":"res://dialogue_system/SpokenLineNoChar.tscn"},"Stage":{"sections":["Intro"],"value":"res://intro/stage/Stage.tscn"},"TitleMenuOpt":{"sections":[],"value":"res://title_screen/TitleMenuOpt.tscn"},"TitleScreen":{"sections":["Intro"],"value":"res://title_screen/TitleScreen.tscn"},"Track":{"sections":[],"value":"res://sounds/Track.tscn"},"TrackManager":{"sections":[],"value":"res://sounds/TrackManager.tscn"},"TransitionScreen":{"sections":[],"value":"res://roaming_pov/TransitionScreen.tscn"},"Wigley":{"sections":[],"value":"res://roaming_pov/Wigley.tscn"},"_ignore_list":["res://addons"],"_sections":["Character","Menu","Sewer","Intro","Infirmary","Maternity","Childrens","Rooftop","Tunnels"],"admin_porch":{"sections":[],"value":"res://infirmary/admin_porch/admin_porch.tscn"},"asbestos_tunnel":{"sections":["Tunnels"],"value":"res://tunnels/asbestos_tunnel/asbestos_tunnel.tscn"},"auditorium":{"sections":["Maternity"],"value":"res://maternity/auditorium/auditorium.tscn"},"auditorium_convo":{"sections":["Maternity"],"value":"res://maternity/auditorium_convo/auditorium_convo.tscn"},"autospy_table":{"sections":["Infirmary"],"value":"res://infirmary/autopsy_table/autospy_table.tscn"},"basement_doc_room":{"sections":["Childrens"],"value":"res://childrens_ward/basement_doc_room/basement_doc_room.tscn"},"basement_out":{"sections":["Tunnels"],"value":"res://tunnels/basement_out/basement_out.tscn"},"basement_room":{"sections":["Tunnels"],"value":"res://tunnels/basement_room/basement_room.tscn"},"basement_surgical":{"sections":[],"value":"res://infirmary/basement_surgical/basement_surgical.tscn"},"bed_overlook":{"sections":["Maternity"],"value":"res://maternity/bed_overlook/bed_overlook.tscn"},"big_leaking_tunnel":{"sections":["Sewer"],"value":"res://sewer/big_leaking_tunnel/big_leaking_tunnel.tscn"},"bottom_of_well":{"sections":["Sewer"],"value":"res://sewer/convo_looking_up_well/bottom_of_well.tscn"},"breezeway":{"sections":["Maternity"],"value":"res://maternity/breezeway/breezeway.tscn"},"bright_arched_hallway":{"sections":["Infirmary"],"value":"res://infirmary/bright_arched_hallway/bright_arched_hallway.tscn"},"cell_grate_convo":{"sections":["Infirmary"],"value":"res://infirmary/cell_grate_convo/cell_grate_convo.tscn"},"chute_room":{"sections":["Infirmary"],"value":"res://infirmary/chute_room/chute_room.tscn"},"come_to_convo":{"sections":["Tunnels"],"value":"res://tunnels/come_to_convo/come_to_convo.tscn"},"conduits_hallway":{"sections":["Infirmary"],"value":"res://infirmary/conduits_hallway/conduits_hallway.tscn"},"conversation_pov":{"sections":[],"value":"res://conversation_pov/conversation_pov.tscn"},"crib_overlook":{"sections":["Maternity"],"value":"res://maternity/crib_overlook/crib_overlook.tscn"},"crib_overlook_convo":{"sections":["Maternity"],"value":"res://maternity/crib_overlook_convo/crib_overlook_convo.tscn"},"crib_overlook_convo_return":{"sections":[],"value":"res://maternity/crib_overlook_convo/crib_overlook_convo_return.tscn"},"cribs_big_room":{"sections":[],"value":"res://top_floor/cribs_big_room/cribs_big_room.tscn"},"cribs_cabinets":{"sections":[],"value":"res://top_floor/cribs_cabinets/cribs_cabinets.tscn"},"cribs_looking_right":{"sections":[],"value":"res://top_floor/cribs_looking_right/cribs_looking_right.tscn"},"cribs_straight_on":{"sections":[],"value":"res://top_floor/cribs_straight_on/cribs_straight_on.tscn"},"curving_tunnel_empty":{"sections":["Sewer"],"value":"res://sewer/curving_tunnel_empty/curving_tunnel_empty.tscn"},"dayroom_chairs":{"sections":[],"value":"res://infirmary/dayroom_chairs/dayroom_chairs.tscn"},"dayroom_empty":{"sections":[],"value":"res://infirmary/dayroom_empty/dayroom_empty.tscn"},"dead_cat_convo":{"sections":["Maternity"],"value":"res://maternity/dead_cat_convo/dead_cat_convo.tscn"},"dome":{"sections":["Maternity"],"value":"res://maternity/dome/dome.tscn"},"door_to_breezeway":{"sections":["Infirmary"],"value":"res://infirmary/door_to_breezeway/door_to_breezeway.tscn"},"drain_stairwell":{"sections":["Sewer"],"value":"res://sewer/drain_stairwell/drain_stairwell.tscn"},"dream_inspection_hallway":{"sections":["Maternity"],"value":"res://maternity/dream_inspection_hallway/dream_inspection_hallway.tscn"},"dream_surgical_overlook":{"sections":["Maternity"],"value":"res://maternity/dream_surgical_overlook/dream_surgical_overlook.tscn"},"elevator_machine_room":{"sections":["Rooftop"],"value":"res://rooftop/elevator_machine_room/elevator_machine_room.tscn"},"end_of_demo":{"sections":[],"value":"res://tunnels/end_of_demo/end_of_demo.tscn"},"flooded_tunnel":{"sections":["Tunnels"],"value":"res://tunnels/flooded_tunnel/flooded_tunnel.tscn"},"front_desk":{"sections":["Maternity"],"value":"res://maternity/front_desk/front_desk.tscn"},"front_desk_convo":{"sections":["Maternity"],"value":"res://maternity/front_desk_convo/front_desk_convo.tscn"},"inspection_hallway":{"sections":["Maternity"],"value":"res://maternity/inspection_hallway/inspection_hallway.tscn"},"inspection_room":{"sections":["Maternity"],"value":"res://maternity/inspection_room/inspection_room.tscn"},"inspection_room_convo":{"sections":[],"value":"res://maternity/inspection_room_convo/inspection_room_convo.tscn"},"intro_convo":{"sections":["Intro"],"value":"res://intro/intro_convo/intro_convo.tscn"},"isolation_cells":{"sections":["Infirmary"],"value":"res://infirmary/isolation_cells/isolation_cells.tscn"},"isolation_stairwell_1f":{"sections":["Infirmary"],"value":"res://infirmary/isolation_stairwell_1f/isolation_stairwell_1f.tscn"},"isolation_stairwell_base":{"sections":["Infirmary"],"value":"res://infirmary/isolation_stairwell_base/isolation_stairwell_base.tscn"},"isolation_wing_top_floor":{"sections":["Infirmary"],"value":"res://infirmary/isolation_wing_top_floor/isolation_wing_top_floor.tscn"},"julia_first_convo":{"sections":["Infirmary"],"value":"res://infirmary/julia_first_convo/julia_first_convo.tscn"},"just_stood_up":{"sections":["Sewer"],"value":"res://sewer/just_stood_up/just_stood_up.tscn"},"ladder_convo":{"sections":["Sewer"],"value":"res://sewer/convo_looking_up_ladder/ladder_convo.tscn"},"ladder_to_hatch":{"sections":["Tunnels"],"value":"res://tunnels/ladder_to_hatch/ladder_to_hatch.tscn"},"machine_room_convo":{"sections":["Rooftop"],"value":"res://rooftop/machine_room_convo/machine_room_convo.tscn"},"mason_drain_corner":{"sections":["Sewer"],"value":"res://sewer/mason_drain_corner/mason_drain_corner.tscn"},"medicine_cabinet":{"sections":["Infirmary"],"value":"res://infirmary/medicine_cabinet/medicine_cabinet.tscn"},"morgue":{"sections":["Infirmary"],"value":"res://infirmary/morgue/morgue.tscn"},"morgue_convo":{"sections":["Infirmary"],"value":"res://infirmary/morgue_convo/morgue_convo.tscn"},"morgue_stairwell_1f":{"sections":["Infirmary"],"value":"res://infirmary/morgue_stairwell_1f/morgue_stairwell_1f.tscn"},"morgue_stairwell_base":{"sections":["Infirmary"],"value":"res://infirmary/morgue_stairwell_base/morgue_stairwell_base.tscn"},"overgrowth_pink_hallway":{"sections":["Infirmary"],"value":"res://infirmary/overgrowth_pink_hallway/overgrowth_pink_hallway.tscn"},"patient_porch":{"sections":[],"value":"res://infirmary/patient_porch/patient_porch.tscn"},"poisoning_convo":{"sections":["Maternity"],"value":"res://maternity/poisoning_convo/poisoning_convo.tscn"},"rectange_tunnel":{"sections":["Tunnels"],"value":"res://tunnels/rectange_tunnel/rectange_tunnel.tscn"},"right_curved_hallway":{"sections":["Maternity"],"value":"res://maternity/right_curved_hallway/right_curved_hallway.tscn"},"roaming_pov":{"sections":[],"value":"res://roaming_pov/roaming_pov.tscn"},"rooftop_outside_elevator":{"sections":["Rooftop"],"value":"res://rooftop/rooftop_outside_elevator/rooftop_outside_elevator.tscn"},"stairwell_office_hallway":{"sections":[],"value":"res://maternity/stairwell_office_hallway/stairwell_office_hallway.tscn"},"tann_office":{"sections":["Infirmary"],"value":"res://infirmary/tann_office/tann_office.tscn"},"telegram_convo":{"sections":["Infirmary"],"value":"res://infirmary/telegram_convo/telegram_convo.tscn"},"telegram_convo_return":{"sections":[],"value":"res://infirmary/telegram_convo/telegram_convo_return.tscn"},"theater_exchange_convo":{"sections":[],"value":"res://top_floor/theater_exchange/theater_exchange_convo.tscn"},"theater_exchange_return_convo":{"sections":[],"value":"res://top_floor/theater_exchange_return/theater_exchange_return_convo.tscn"},"tilted_dream_hallway_1":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_1.tscn"},"tilted_dream_hallway_2":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_2.tscn"},"tilted_dream_hallway_3":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_3.tscn"},"tilted_dream_hallway_4":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_4.tscn"},"tilted_dream_hallway_5":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_5.tscn"},"tilted_dream_hallway_6":{"sections":["Maternity"],"value":"res://maternity/tilted_dream_hallways/tilted_dream_hallway_6.tscn"},"top_floor_middle_hallway":{"sections":["Infirmary"],"value":"res://infirmary/top_floor_middle_hallway/top_floor_middle_hallway.tscn"},"trash_chute":{"sections":["Infirmary"],"value":"res://infirmary/trash_chute/trash_chute.tscn"},"tunnel_leading_down":{"sections":["Tunnels"],"value":"res://tunnels/tunnel_leading_down/tunnel_leading_down.tscn"},"vera_diary_convo_1":{"sections":["Infirmary"],"value":"res://infirmary/vera_diary_convo_1/vera_diary_convo_1.tscn"},"vera_diary_convo_1_return":{"sections":[],"value":"res://infirmary/vera_diary_convo_1/vera_diary_convo_1_return.tscn"},"vera_diary_convo_2":{"sections":["Infirmary"],"value":"res://infirmary/vera_diary_convo_2/vera_diary_convo_2.tscn"},"vera_diary_convo_2_return":{"sections":[],"value":"res://infirmary/vera_diary_convo_2/vera_diary_convo_2_return.tscn"},"vera_new_office":{"sections":["Maternity"],"value":"res://maternity/vera_new_office/vera_new_office.tscn"},"vera_new_office_convo":{"sections":["Maternity"],"value":"res://maternity/vera_new_office_convo/vera_new_office_convo.tscn"},"vera_office":{"sections":["Infirmary"],"value":"res://infirmary/vera_office/vera_office.tscn"},"visitors_log_convo":{"sections":[],"value":"res://childrens_ward/visitors_log_convo/visitors_log_convo.tscn"},"wash_room":{"sections":["Infirmary"],"value":"res://infirmary/wash_room/wash_room.tscn"},"washing_machine_trio":{"sections":["Infirmary"],"value":"res://infirmary/washing_machine_trio/washing_machine_trio.tscn"},"washing_machine_trio_w_julia":{"sections":[],"value":"res://infirmary/washing_machine_trio_w_julia/washing_machine_trio_w_julia.tscn"}}
