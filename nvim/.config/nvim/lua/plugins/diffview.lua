return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewFileHistory",
      "DiffviewFocusFiles",
      "DiffviewToggleFiles",
      "DiffviewRefresh",
    },
    keys = {
      { "<leader>gvv", "<cmd>DiffviewOpen<cr>", desc = "Diff Working Tree" },
      { "<leader>gvb", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "Diff vs Base Branch" },
      { "<leader>gvh", "<cmd>DiffviewFileHistory<cr>", desc = "Repo History" },
      { "<leader>gvf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
      { "<leader>gvf", ":DiffviewFileHistory<cr>", mode = "v", desc = "Range History" },
      { "<leader>gvc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        -- start on a 2-way diff; `g<C-x>` cycles to 3-way during merges
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_mixed", disable_diagnostics = true },
      },
      file_panel = {
        listing_style = "tree",
        win_config = { width = 30 },
      },
      keymaps = {
        view = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
        file_history_panel = { { "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" } } },
      },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>gv", group = "diffview", icon = { icon = " ", color = "orange" } },
      },
    },
  },
}
