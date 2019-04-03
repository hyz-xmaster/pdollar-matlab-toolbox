function [train_set, val_set] = split_set(label, val_ratio)
    train_set = [];
    val_set = [];
    label_id = unique(label);
    for i = 1:length(label_id)
        label_index = find(label == label_id(i));
        val_set_t = datasample(label_index, ceil(numel(label_index)*val_ratio));
        val_set = [val_set; val_set_t];
    end
    train_set = setdiff(1:length(label), val_set);
    train_set = train_set(:);
    val_set=sort(val_set);
end
