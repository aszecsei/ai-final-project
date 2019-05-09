import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import matplotlib
from math import sqrt

SPINE_COLOR = 'gray'


def latexify(fig_width=None, fig_height=None, columns=1):
    """Set up matplotlib's RC params for LaTeX plotting.
    Call this before plotting a figure.

    Parameters
    ----------
    fig_width : float, optional, inches
    fig_height : float,  optional, inches
    columns : {1, 2}
    """

    # code adapted from http://www.scipy.org/Cookbook/Matplotlib/LaTeX_Examples

    # Width and max height in inches for IEEE journals taken from
    # computer.org/cms/Computer.org/Journal%20templates/transactions_art_guide.pdf

    assert(columns in [1, 2])

    if fig_width is None:
        fig_width = 3.39 if columns == 1 else 6.9  # width in inches

    if fig_height is None:
        golden_mean = (sqrt(5)-1.0)/2.0    # Aesthetic ratio
        fig_height = fig_width*golden_mean  # height in inches

    MAX_HEIGHT_INCHES = 8.0
    if fig_height > MAX_HEIGHT_INCHES:
        print("WARNING: fig_height too large:" + fig_height +
              "so will reduce to" + MAX_HEIGHT_INCHES + "inches.")
        fig_height = MAX_HEIGHT_INCHES

    params = {'backend': 'ps',
              'text.latex.preamble': ['\\usepackage{gensymb}'],
              'axes.labelsize': 8,  # fontsize for x and y labels (was 10)
              'axes.titlesize': 8,
              'font.size': 8,  # was 10
              'legend.fontsize': 8,  # was 10
              'xtick.labelsize': 8,
              'ytick.labelsize': 8,
              'text.usetex': True,
              'figure.figsize': [fig_width, fig_height],
              'font.family': 'serif'
              }

    matplotlib.rcParams.update(params)


def format_axes(ax):

    for spine in ['top', 'right']:
        ax.spines[spine].set_visible(False)

    for spine in ['left', 'bottom']:
        ax.spines[spine].set_color(SPINE_COLOR)
        ax.spines[spine].set_linewidth(0.5)

    ax.xaxis.set_ticks_position('bottom')
    ax.yaxis.set_ticks_position('left')

    for axis in [ax.xaxis, ax.yaxis]:
        axis.set_tick_params(direction='out', color=SPINE_COLOR)

    return ax


def generate_errt_vs_errv_chart(data, dataset, display_dataset, algorithm):
    print("Generating err_t vs err_v chart - {} - {}".format(dataset, algorithm))
    chart1_df = data[(data.DataSource ==
                      dataset) & (data.Algorithm == algorithm)]
    chart1_df = chart1_df[['MaxDepth', 'ErrT', 'ErrV']]
    chart1_df_mean = chart1_df.groupby(['MaxDepth']).mean()
    latexify()
    ax = chart1_df_mean.plot()
    ax.set_xlabel("Max Depth Constraint")
    ax.set_ylabel("Error")
    # ax.set_title(
    #     "Effects of Depth Constraint on {} Dataset".format(display_dataset))
    plt.tight_layout()
    format_axes(ax)
    plt.savefig(
        "./technical-report/figures/chart_errt_errv_{}_{}.pdf".format(dataset.lower(), algorithm.lower()))


def generate_variance_chart(data, dataset, display_dataset, algorithm):
    print("Generating variance chart - {} - {}".format(dataset, algorithm))
    chart1_df = data[(data.DataSource ==
                      dataset) & (data.Algorithm == algorithm)]
    chart1_df = chart1_df[['MaxDepth', 'ErrV']]
    chart1_df_mean = chart1_df.groupby(['MaxDepth'], as_index=True).mean()
    chart1_df_std = chart1_df.groupby(['MaxDepth'], as_index=True).std()
    latexify()
    ax = chart1_df_mean.plot()
    ax.fill_between(chart1_df_std.index, chart1_df_mean.loc[:, 'ErrV'] - 2 *
                    chart1_df_std.loc[:, 'ErrV'], chart1_df_mean.loc[:, 'ErrV'] + 2*chart1_df_std.loc[:, 'ErrV'], color='b', alpha=0.2)
    ax.set_xlabel("Max Depth Constraint")
    ax.set_ylabel("Error")
    # ax.set_title(
    #     "Effects of Depth Constraint on {} Dataset".format(display_dataset))
    plt.tight_layout()
    format_axes(ax)
    plt.savefig(
        "./technical-report/figures/chart_variance_{}_{}.pdf".format(dataset.lower(), algorithm.lower()))


def generate_ours_v_scikit_chart(data, dataset, display_dataset):
    print("Generating ours v scikit chart - {}".format(dataset))
    chart1_df_ours = data[(data.DataSource ==
                           dataset) & (data.Algorithm == 'OURS')]
    chart1_df_scikit = data[(data.DataSource ==
                             dataset) & (data.Algorithm == 'SCIKIT')]
    chart1_df_ours = chart1_df_ours[['MaxDepth', 'ErrV']]
    chart1_df_scikit = chart1_df_scikit[['MaxDepth', 'ErrV']]
    chart1_df_ours_mean = chart1_df_ours.groupby(
        ['MaxDepth']).mean().rename(columns={"ErrV": "Our ErrV"})
    chart1_df_scikit_mean = chart1_df_scikit.groupby(
        ['MaxDepth']).mean().rename(columns={"ErrV": "SciKit ErrV"})
    chart1_df_mean = pd.merge(
        chart1_df_ours_mean, chart1_df_scikit_mean, on='MaxDepth')
    latexify()
    ax = chart1_df_mean.plot()
    ax.set_xlabel("Max Depth Constraint")
    ax.set_ylabel("Error")
    # ax.set_title(
    #     "Effects of Depth Constraint on {} Dataset".format(display_dataset))
    plt.tight_layout()
    format_axes(ax)
    plt.savefig(
        "./technical-report/figures/chart_ours_v_scikit_{}.pdf".format(dataset.lower()))


def generate_ours_v_scikit_variance_chart(data, dataset, display_dataset):
    print("Generating ours v scikit variance chart - {}".format(dataset))
    chart1_df_ours = data[(data.DataSource ==
                           dataset) & (data.Algorithm == 'OURS')]
    chart1_df_scikit = data[(data.DataSource ==
                             dataset) & (data.Algorithm == 'SCIKIT')]
    chart1_df_ours = chart1_df_ours[['MaxDepth', 'ErrV']]
    chart1_df_scikit = chart1_df_scikit[['MaxDepth', 'ErrV']]
    chart1_df_ours_mean = chart1_df_ours.groupby(
        ['MaxDepth']).mean().rename(columns={"ErrV": "Our ErrV"})
    chart1_df_ours_std = chart1_df_ours.groupby(
        ['MaxDepth']).std()
    chart1_df_scikit_mean = chart1_df_scikit.groupby(
        ['MaxDepth']).mean().rename(columns={"ErrV": "SciKit ErrV"})
    chart1_df_scikit_std = chart1_df_scikit.groupby(
        ['MaxDepth']).std()
    chart1_df_mean = pd.merge(
        chart1_df_ours_mean, chart1_df_scikit_mean, on='MaxDepth')
    latexify()
    ax = chart1_df_mean.plot()
    ax.fill_between(chart1_df_ours_std.index, chart1_df_ours_mean.loc[:, 'Our ErrV'] - 2 *
                    chart1_df_ours_std.loc[:, 'ErrV'], chart1_df_ours_mean.loc[:, 'Our ErrV'] + 2*chart1_df_ours_std.loc[:, 'ErrV'], color='C0', alpha=0.2)
    ax.fill_between(chart1_df_scikit_std.index, chart1_df_scikit_mean.loc[:, 'SciKit ErrV'] - 2 *
                    chart1_df_scikit_std.loc[:, 'ErrV'], chart1_df_scikit_mean.loc[:, 'SciKit ErrV'] + 2*chart1_df_scikit_std.loc[:, 'ErrV'], color='C1', alpha=0.2)
    ax.set_xlabel("Max Depth Constraint")
    ax.set_ylabel("Error")
    # ax.set_title(
    #     "Effects of Depth Constraint on {} Dataset".format(display_dataset))
    plt.tight_layout()
    format_axes(ax)
    plt.savefig(
        "./technical-report/figures/chart_ours_v_scikit_variance_{}.pdf".format(dataset.lower()))


if __name__ == "__main__":
    data = pd.read_csv(
        './data.csv', names=['DataSource', 'Algorithm', 'MaxDepth', 'ErrT', 'ErrV'])

    generate_errt_vs_errv_chart(data, 'BALANCE', 'Balance', 'OURS')
    generate_errt_vs_errv_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS')
    generate_errt_vs_errv_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS')
    generate_errt_vs_errv_chart(data, 'CAR', 'Car Evaluation', 'OURS')

    generate_errt_vs_errv_chart(data, 'BALANCE', 'Balance', 'SCIKIT')
    generate_errt_vs_errv_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'SCIKIT')
    generate_errt_vs_errv_chart(data, 'MUSHROOMS', 'Mushrooms', 'SCIKIT')
    generate_errt_vs_errv_chart(data, 'CAR', 'Car Evaluation', 'SCIKIT')

    generate_variance_chart(data, 'BALANCE', 'Balance', 'OURS')
    generate_variance_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'OURS')
    generate_variance_chart(data, 'MUSHROOMS', 'Mushrooms', 'OURS')
    generate_variance_chart(data, 'CAR', 'Car Evaluation', 'OURS')

    generate_variance_chart(data, 'BALANCE', 'Balance', 'SCIKIT')
    generate_variance_chart(data, 'TICTACTOE', 'Tic-Tac-Toe', 'SCIKIT')
    generate_variance_chart(data, 'MUSHROOMS', 'Mushrooms', 'SCIKIT')
    generate_variance_chart(data, 'CAR', 'Car Evaluation', 'SCIKIT')

    generate_ours_v_scikit_chart(data, 'BALANCE', 'Balance')
    generate_ours_v_scikit_chart(data, 'TICTACTOE', 'Tic-Tac-Toe')
    generate_ours_v_scikit_chart(data, 'MUSHROOMS', 'Mushrooms')
    generate_ours_v_scikit_chart(data, 'CAR', 'Car Evaluation')

    generate_ours_v_scikit_variance_chart(data, 'BALANCE', 'Balance')
    generate_ours_v_scikit_variance_chart(data, 'TICTACTOE', 'Tic-Tac-Toe')
    generate_ours_v_scikit_variance_chart(data, 'MUSHROOMS', 'Mushrooms')
    generate_ours_v_scikit_variance_chart(data, 'CAR', 'Car Evaluation')
