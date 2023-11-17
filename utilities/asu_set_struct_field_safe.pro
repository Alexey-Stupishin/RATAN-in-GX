pro asu_set_struct_field_safe, index, key, value

    tag_names = tag_names(index)
    idx_shift_hmi = where(strupcase(tag_names) eq key, count)
    if count eq 0 then begin
        index = create_struct(key, value, index)
    endif else begin
        index.(idx_shift_hmi) = value
    endelse

end
