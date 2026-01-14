import math
from client.solver import ProductionHJISolver


def make_solver_with_cfg():
    s = ProductionHJISolver.__new__(ProductionHJISolver)
    s.cfg = {
        'market_assumptions': {
            'jit_gas_usage': 21000,
            'kappa': 1e-9,
            'v_swap_nominal': 1e6,
        }
    }
    return s


def test_solve_phi_crit_returns_reasonable_value():
    s = make_solver_with_cfg()
    # typical inputs
    ratio_bps = 100  # 1%
    L_active = 1_000_000
    gas_price = int(100 * 1e9)  # 100 gwei
    v_swap = 1e6

    phi = s.solve_phi_crit(ratio_bps, L_active, gas_price, v_swap)

    assert isinstance(phi, float)
    assert phi > 0
    assert phi < 1
