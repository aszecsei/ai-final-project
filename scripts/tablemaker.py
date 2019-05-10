import pandas as pd

if __name__ == "__main__":
    data = pd.read_csv(
        './data.csv', names=['DataSource', 'Algorithm', 'MaxDepth', 'ErrT', 'ErrV'])

    ds = ['MUSHROOMS', 'BALANCE', 'TICTACTOE', 'CARS']
    data_filtered = data[['DataSource', 'Algorithm', 'MaxDepth', 'ErrV']]
    data_filtered = data_filtered[(data.Algorithm == 'SCIKIT')]
    data_grouped_mean = data_filtered.groupby(
        ['DataSource', 'MaxDepth']).mean().rename(columns={"ErrV": "Error"})
    data_grouped_std = data_filtered.groupby(['DataSource', 'MaxDepth']).std(
    ).rename(columns={"ErrV": "Standard Deviation"})
    data_grouped_mean = data_grouped_mean.reset_index().set_index('MaxDepth')
    data_grouped_std = data_grouped_std.reset_index().set_index('MaxDepth')

    data_merged = pd.merge(
        data_grouped_mean, data_grouped_std, on=['DataSource', 'MaxDepth'])
    data_merged = pd.pivot(data_merged, columns='DataSource')
    data_merged = data_merged.swaplevel(i=0, j=1, axis=1)
    data_merged.sort_index(axis=1, level=0, inplace=True)
    # print(data_merged)

    print(data_merged.to_latex(index=True))
